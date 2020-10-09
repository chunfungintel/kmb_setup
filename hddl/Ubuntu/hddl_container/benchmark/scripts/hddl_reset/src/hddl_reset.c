// SPDX-License-Identifier: GPL-2.0-only
/*
 * hddl_reset.c - Userspace reset driver to support hard/soft rest for hddl device.
 *
 * Copyright (C) 2019-2020 Intel Corporation
 */

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <ctype.h>
#include "../inc/hddl_reset.h"
#include <errno.h>

#define HDDL_BUFFER_MAX 5 // max buffer size for gpio pin no.
#define HDDL_VALUE_MAX 64 // max  buffer size for storing sysfs path
#define HDDL_MAX_GPIO_BASE 10000  
#define HDDL_LOW  0
#define HDDL_HIGH 1
#define HDDL_IN 0
#define HDDL_OUT 1


static int power(int x, unsigned int y)
{
	if (y == 0)
		return 1;
	else if (y%2 == 0)
		return power(x, y/2)*power(x, y/2);
	else
		return x*power(x, y/2)*power(x, y/2);
}

static int open_file(char *file, int flag)
{
	int filefd;

	filefd = openat(AT_FDCWD, file, flag);
	if(-1 == filefd)
	{
		printf("File open Failed %d %s\n",errno,file);
		return -1;
	}

	return filefd;
}

/*
 *  reset_gpio_export : Export the particular GPIO pin for user control
 */
static int reset_gpio_export(int pin)
{
	char buffer[HDDL_BUFFER_MAX];
	ssize_t bytes_written;
	int fd;

	fd = open_file("/sys/class/gpio/export", O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "HDDL_RESET: Failed to open export for writing!\n");
		printf("HDDL_RESET: Failed to open export for writing!\n");
		return -1;	
	}

	bytes_written = snprintf(buffer, HDDL_BUFFER_MAX, "%d", pin);
	if(-1==write(fd, buffer, bytes_written))
	{
		printf("Write error %d\n",errno);
		goto error;
	}

	close(fd);
	return(0);

error:
	close(fd);
	return(-1);
}

/*
 *  reset_gpio_unexport - Unexport the particular GPIO pin for user control
 */
static int reset_gpio_unexport(int pin)
{
	char buffer[HDDL_BUFFER_MAX];
	ssize_t bytes_written;
	int fd;

	fd = open_file("/sys/class/gpio/unexport", O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "HDDL_RESET: Failed to open unexport for writing!\n");
		goto error;
	}

	bytes_written = snprintf(buffer, HDDL_BUFFER_MAX, "%d", pin);
	if (write(fd, buffer, bytes_written) == -1)
	{
		goto error;
	}
	close(fd);
	return(0);

error:
	close(fd);
	return(-1);
}

/*
 *  reset_gpio_read - Read the particular GPIO pin
 */
static int reset_gpio_read(int pin)
{
	char path[HDDL_VALUE_MAX];
	char value_str[3];
	int fd;

	snprintf(path, HDDL_VALUE_MAX, "/sys/class/gpio/gpio%d/value", pin);
	fd = open_file(path, O_RDONLY);
	if (-1 == fd) {
		fprintf(stderr, "HDDL_RESET: Failed to open gpio value for reading!\n");
		return -1;
	}

	if (-1 == read(fd, value_str, 3)) {
		fprintf(stderr, "HDDL_RESET: Failed to read value!\n");
		goto error;
	}

	close(fd);

	return(atoi(value_str));
error:
	close(fd);
	return(-1);
}

/*
 *  reset_gpio_write - Write the particular GPIO pin
 */
static int reset_gpio_write(int pin, int value)
{
	char path[HDDL_VALUE_MAX];
	int fd;
	snprintf(path, HDDL_VALUE_MAX, "/sys/class/gpio/gpio%d/value", pin);
	fd = open_file(path, O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "HDDL_RESET: Failed to open gpio value for writing!\n");
		return -1;
	}

	if(value ==0){
		if(write(fd, "0", 1) != 1){
			fprintf(stderr, "HDDL_RESET: Failed to write value!\n");
			goto error;
		}
		}else{
		if(write(fd, "1", 1) != 1){
			fprintf(stderr, "HDDL_RESET: Failed to write value!\n");
			goto error;
		}
	}

	close(fd);
	return(0);
error:
	close(fd);
	return(-1);
}

/*
 *  reset_gpio_direction - Change the GPIO pin direction to in/out 
 */
static int reset_gpio_direction(int pin,int dir )
{
	static const char s_directions_str[]  = "in\0out";
	char path[HDDL_VALUE_MAX];
	int fd;

	snprintf(path, HDDL_VALUE_MAX, "/sys/class/gpio/gpio%d/direction", pin);
	fd = open_file(path, O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "HDDL_RESET: Failed to open gpio direction for writing!\n");
		return -1;
	}

	if (-1 == write(fd, &s_directions_str[HDDL_IN == dir ? 0 : 3], HDDL_IN == dir ? 2 : 3)
		) {
		fprintf(stderr, "HDDL_RESET: Failed to set direction!\n");
		goto error;
	}

	close(fd);
	return(0);

error:
	close(fd);
	return(-1);
}

/*
 *  pcie_check - check if  ASMEDIA DRIVER for pcie is present or not in linux system 
 */
static int pcie_check(void)
{
	int fdir;

	fdir = openat(AT_FDCWD, "/sys/module/Gpio_asm28xx", O_DIRECTORY | O_RDONLY);
	if(-1 == fdir)
		return 0;

	close(fdir);
	return 1;
}

/*
 *  pcie_gpio_base - mapping hddl board id with gpiochip base
 */
static int pcie_gpio_base(int board_id){


	int max_board = 0;
	char buf[HDDL_VALUE_MAX];
	int j,id;
	int srb_id =0;
	int fc,fd;
	int base;
	int srb_bits;
	struct dirent *dir;
	char *chip, *s;
	DIR *fdir;
	int len = strlen("ASMEDIA GPIO");
	char *c = (char *) calloc(100, sizeof(char));
	if(!c)
		return -1;

	snprintf(buf, HDDL_VALUE_MAX, "/sys/class/gpio");
	fc = openat(AT_FDCWD, buf, O_DIRECTORY );
	if(-1 == fc){
		free(c);
		return -1;
	}

	fdir = fdopendir(fc);
	if(!fdir){
		free(c);
		close(fc);
		return -1;
	}

	while((dir = readdir(fdir)) != NULL)
	{
		if(max_board > 7)
			goto err;

		s = strstr(dir->d_name,"gpiochip");
		if(s){
			chip = strtok(s, "gpiochip");
			if(!chip)
				goto err;

			id = strtol(chip, &chip,10);
			if(id < 0 || id > HDDL_MAX_GPIO_BASE)
				goto err;

			memset(buf , 0 , HDDL_VALUE_MAX);
			snprintf(buf, HDDL_VALUE_MAX, "/sys/class/gpio/gpiochip%d/label", id);
			fd = open_file(buf, O_RDONLY);
			if(fd == -1)
				goto err;

			if ( -1 == read(fd,c,12))
				goto err1;

			if(strncmp(c, "ASMEDIA GPIO", len) == 0){
				max_board++;
				base = id;
				for(j =0;j<3;j++){
					if(-1 == reset_gpio_export(base+j))
						goto err1;
					
					srb_bits = reset_gpio_read(base+j);
					if(srb_bits < 0 || srb_bits > 1 )
						goto err1;
					
					srb_id += srb_bits * power(2,j);
					if(srb_id < 0 || srb_id > 7){
				        	reset_gpio_unexport(base+j);
						goto err1;
					}

					if (srb_id == board_id)
					{ 
						if(-1 == reset_gpio_unexport(base+j))
							goto err1;
						
						free(c);
						closedir(fdir);	
						close(fd);
						return base;
					}
					if(-1 == reset_gpio_unexport(base+j))
						goto err1;
				}
				srb_bits = 0;
			}
		}
	}

err:
	free(c);
	closedir(fdir);
	return -1;
err1:
	free(c);
	closedir(fdir);
	close(fd);
	return -1;
}

/*
 *  find_i2c() - find i2c bus number, which will help to check presence of SMBus-i801 in linux system
 */
static int find_i2c(){
	char buf[HDDL_VALUE_MAX];
	int fc;
	int len = strlen("SMBus I801");
	char *c = (char *) calloc(100, sizeof(char));
	if(!c)
		return -1;

	for(int i=0;i<10;i++){

		snprintf(buf, HDDL_VALUE_MAX, "/sys/bus/i2c/devices/i2c-%d/name", i);
		fc = open_file(buf, O_RDONLY);
		if (fc == -1) {
			perror("HDDL_RESET: Unable to open file for i2c-device");
			free(c);
			return -1;
		}
		if( -1 == read(fc,c,10))
			goto cleanup;
		
		if(strncmp(c, "SMBus I801", len)==0)
		{
			free(c);
			close(fc);
			return i;
		}
		close(fc);
	}

cleanup:
	free(c);
	close(fc);

	return -1;
}

/*
 *  ioexpander_gpio_base - mapping hddl board id with gpiochip base for ioexpander driver
 */
static int ioexpander_gpio_base(int i2c_no , int hddl){
	char buf[HDDL_VALUE_MAX];
	int v = 0;
	char *chip = NULL;
	int fdir;
	DIR *dir;
	char *ptr;
	long val;
	struct dirent *direntry;

	snprintf(buf, HDDL_VALUE_MAX, "/sys/module/gpio_pca953x/drivers/i2c:pca953x/%d-00%x/gpio/",
	i2c_no,hddl);
	fdir = openat(AT_FDCWD, buf, O_DIRECTORY | O_RDONLY);
	if(-1 == fdir)
		return -1;

	dir = fdopendir(fdir);
	if(!dir)
		return -1;

	while ((direntry = readdir(dir)) != NULL){
		if((strcmp(direntry->d_name, ".")!=0)&&(strcmp(direntry->d_name, "..")!=0)){
			chip = direntry->d_name;
		}
	}
	closedir(dir);
	if (chip == NULL)
	{
			return -1;
	}

	ptr = chip;
	while (*ptr) {
		if (isdigit(*ptr)) {
			val = strtol(ptr, &ptr, 10);
			v =val;
			} else {
			ptr++;
		}
	}
	return v;
}

/*
 * i2c_new_device - Create i2c new device for ioexpander driver 
 */
static int i2c_new_device (int i2c, int hddl)
{
	char pca_add[HDDL_VALUE_MAX];
	snprintf(pca_add, HDDL_VALUE_MAX, "pca9555 0x%x", hddl);
	char buf[HDDL_VALUE_MAX];
	int fd;

	snprintf(buf, HDDL_VALUE_MAX, "/sys/bus/i2c/devices/i2c-%d/new_device", i2c);
	fd = open_file(buf, O_WRONLY);
	if (fd == -1) {
		perror("HDDL_RESET: Unable to open file for i2c new_device");
		return -1;
	}
	snprintf(buf, HDDL_VALUE_MAX, "%s", pca_add);
	if (write(fd, buf,strlen(buf)) != strlen(buf)) {
		perror("HDDL_RESET: Error writing to i2c new_device");
		close(fd);
		return -1;
	}
	close(fd);
	return 0;

}

/*
 * i2c_delete_device - Delete i2c device created for ioexpander driver from i2c_new_device()
 */
int i2c_delete_device(int i2c, int hddl)
{
	char pca_delete[HDDL_VALUE_MAX];
	snprintf(pca_delete, HDDL_VALUE_MAX, "0x%x", hddl);
	char buf[HDDL_VALUE_MAX];
	int fd;

	snprintf(buf, HDDL_VALUE_MAX, "/sys/bus/i2c/devices/i2c-%d/delete_device", i2c);
	fd = open_file(buf, O_WRONLY);
	if (fd == -1) {
		perror("HDDL_RESET: Unable to open i2c delete_device");
		return -1;
	}

	snprintf(buf, HDDL_VALUE_MAX, "%s", pca_delete);
	if (write(fd, buf,strlen(buf)) != strlen(buf)) {
		perror("HDDL_RESET: Error writing to i2c delete_device");
		close(fd);
		return -1;
	}
	close(fd);
	return 0;
}

/*
 * hddl_soft_reset - It will trigger reset via xlink 
 */
int hddl_soft_reset ( int sw_id )
{
	int fd;
	T_SW_ID_SOFT_RESET soft_reset;
	soft_reset.sw_id = sw_id;
	soft_reset.return_id = 0;
	/****ioctl*****/
	fd = open_file("/dev/hddl_device", O_RDWR);
	if(fd < 0)
	{
		printf("HDDL_RESET: Cannot open device file...\n");
		return 0;
	}
	if(ioctl(fd, HDDL_SOFT_RESET,&soft_reset) == -1) {
		printf("HDDL_RESET:  ioctl error \n");
		close(fd);
		return 0;
	}
	if (soft_reset.return_id !=1)
		return 0;

	close(fd);
	return 1;
/****ioctl-end****/
}

/*
 * hddl_hard_reset - It will trigger reset via pcie or ioexpander
   Note: if pcie driver already installed in system then hard reset done via pcie else it will use ioexpander to trigger hard reset
 */
int hddl_hard_reset(int sw_id)
{
	int pcie_found;
	int pcie_gbase;
	int i2c;
	int i2c_device;
	int ioe_gpio_kmb;
	int fd;
	int kmb ,hddl;
	T_SW_ID_HDDL_DATA swid_data = {0};

/****ioctl*****/
	fd = open_file("/dev/hddl_device", O_RDWR);
		if(fd < 0)
		{
			printf("HDDL_RESET: Cannot open device file...\n");
			return 0;
		}
	swid_data.sw_id = sw_id;
	printf("sw_id = %d\n",sw_id);
	printf("swid_data.sw_id = %d\n",swid_data.sw_id);
	if (ioctl(fd, HDDL_READ_SW_ID_DATA, &swid_data) == -1) {
		printf("HDDL_RESET: ioctl error \n");
		close(fd);
		return 0;
	}
	if(swid_data.return_id !=1)
	{
		printf("HDDL_RESET: invalid xlink sw_id\n");
		close(fd);
		return 0;
	}
	hddl = swid_data.board_id;
	kmb = swid_data.soc_id & 0xF;
	close(fd);
/****ioctl-end****/
	if(kmb >2 || hddl > 7)
	{
 		printf("HDDL_RESET:  kmb_id >2 or hddl_id >7 \n");
	 	return 0;
	}

	// check for ASMEDIA driver for PCIE
	pcie_found=pcie_check();

	if (pcie_found == 1)
	{
		int pcie_gpio_kmb;
		// Find GPIOChip base for ASMedia PCIE
		pcie_gbase = pcie_gpio_base(hddl);
		if (pcie_gbase!= -1)
		{
			if ( kmb == 0){
				pcie_gpio_kmb = 4;
			}
			else{
				pcie_gpio_kmb = 5+kmb;
			}
			if(-1 ==reset_gpio_export(pcie_gpio_kmb))
				return 0;
			if (-1 ==reset_gpio_direction(pcie_gpio_kmb , 1))
				return 0;
			if(-1 == reset_gpio_write(pcie_gpio_kmb, 1))
				return 0;
			usleep(5000);
			if (-1 == reset_gpio_write(pcie_gpio_kmb, 0))
				return 0;
			if(-1==reset_gpio_unexport(pcie_gpio_kmb))
				return 0;
		}
		else
			return 0;
	}
	else{
		hddl= (0x20|hddl);
		// finding i2c adapter for smbus
		i2c = find_i2c();
		if(i2c ==-1)
		{
			return 0;
		}
		// i2c new devices
		i2c_device = i2c_new_device(i2c,hddl);
		if( -1 ==i2c_device)
			return 0;
		// find base for ioexpander
		ioe_gpio_kmb = ioexpander_gpio_base(i2c , hddl);
		if ( ioe_gpio_kmb < 0  || ioe_gpio_kmb > HDDL_MAX_GPIO_BASE){
			i2c_delete_device(i2c, hddl);
			return 0;
		}
		ioe_gpio_kmb = ioe_gpio_kmb + kmb;
		if(-1 ==reset_gpio_export(ioe_gpio_kmb)){
			i2c_delete_device(i2c, hddl);
			return 0;
		}

		if(-1 ==reset_gpio_direction(ioe_gpio_kmb , 1)){
			i2c_delete_device(i2c, hddl);
			return 0;
		}

		if (-1 == reset_gpio_write(ioe_gpio_kmb, 0)){
			i2c_delete_device(i2c, hddl);
			return 0;
		}

		usleep(5000);

		if (-1 == reset_gpio_write(ioe_gpio_kmb, 1)){
			i2c_delete_device(i2c, hddl);
			return 0;
		}

		if(-1 == reset_gpio_unexport(ioe_gpio_kmb)){
			i2c_delete_device(i2c, hddl);
			return 0;
		}

		if(-1==i2c_delete_device(i2c, hddl))
			return 0;
	}
	return 1;

}
/*
        hddl_soc_reset : public api to reset KMB device 
                         reset_type : Type of reset to perform on KMB.
                         sw_id      : xlink sw_id which need to reset 

*/

int hddl_soc_reset (enum reset_type r_t,int sw_id){

	switch (r_t){
		case soft_reset:
			if (hddl_soft_reset(sw_id) == 0) {
				printf("HDDL_RESET:  Soft reset failed ...\n");
				return 0;
			}
			return 1;
		case hard_reset:
			if ( hddl_hard_reset(sw_id) == 0) {
				printf ( "HDDL_RESET:  Hard reset failed ...\n");
				return 0;
			}
			return 1;
		default:
			printf("HDDL_RESET:  Unknown reset type...\n");
		return 0;
	}
}
