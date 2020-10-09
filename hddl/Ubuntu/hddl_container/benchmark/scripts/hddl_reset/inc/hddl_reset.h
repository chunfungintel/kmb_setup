// SPDX-License-Identifier: GPL-2.0-only
/*
 * hddl_reset.h - Userspace reset driver to support hard/soft rest for hddl device.
 *
 * Copyright (C) 2019-2020 Intel Corporation
 */

#include<stdio.h>
#include<sys/ioctl.h>
#include<stdint.h>

#define HDDL_MAGIC 'x'
#define HDDL_READ_SW_ID_DATA    	_IOW(HDDL_MAGIC,'a',void*)
#define HDDL_SOFT_RESET 		_IOW(HDDL_MAGIC,'b',void*)


/*
	reset_type to be selected for hddl KMB reset.

*/
enum reset_type{soft_reset,hard_reset};

/*
		public api to reset KMB
		reset_type : Type of reset to perform on Hddl.
		sw_id : xlink sw_id which need to reset 

*/
extern int hddl_soc_reset (enum reset_type r_t,int sw_id);

typedef struct sw_id_hddl_data {
	uint32_t board_id;
	uint32_t soc_id;
	uint32_t soc_adaptor_no[2];
	uint32_t sw_id;
	uint32_t return_id;
}T_SW_ID_HDDL_DATA;

typedef struct sw_id_soft_reset {
	uint32_t sw_id;
	uint32_t return_id;
}T_SW_ID_SOFT_RESET;


