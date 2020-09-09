#!/bin/bash
# ==============================================================================
# Copyright (C) <2018-2019> Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

modprobe hantrodriver
export GST_VAAPI_ALL_DRIVERS=1

export LD_LIBRARY_PATH=/opt/openvino/opencv/lib:/opt/openvino/deployment_tools/ngraph/lib:/opt/openvino/deployment_tools/inference_engine/external/hddl_unite/lib:/opt/openvino/deployment_tools/inference_engine/external/hddl/lib:/opt/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/openvino/deployment_tools/inference_engine/lib/aarch64:${LD_LIBRARY_PATH}

export ENABLE_GVA_FEATURES=compact-meta

echo [setup_env.sh] GVA plugin Yocto environment is initialized
