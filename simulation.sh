#!/bin/bash

export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
export HYDRA_FULL_ERROR=1
export PYTHONWARNINGS="ignore"
export PYTHONPATH=$PYTHONPATH:$(pwd)

cwd=$(pwd)
CKPT_ROOT="$cwd/checkpoints"

PLANNER=pluto_planner

# BUILDER=nuplan_mini
# FILTER=mini_demo_scenario

BUILDER=nuplan
FILTER=val14_benchmark

# FILTER=val14_benchmark

CKPT=last316.ckpt
# CKPT=pluto_1M_aux_cil_official.ckpt

VIDEO_SAVE_DIR=/inspire/hdd/ws-f4d69b29-e0a5-44e6-bd92-acf4de9990f0/public-project/lihongchen-240108020027/proj/Planning/pluto/videos


CHALLENGE="closed_loop_nonreactive_agents"
# CHALLENGE="closed_loop_reactive_agents"
# CHALLENGE="open_loop_boxes"

python run_simulation.py \
    +simulation=$CHALLENGE \
    planner=$PLANNER \
    scenario_builder=$BUILDER \
    scenario_filter=$FILTER \
    verbose=true \
    worker=ray_distributed \
    worker.threads_per_node=18 \
    distributed_mode='SINGLE_NODE' \
    number_of_gpus_allocated_per_simulation=0.15 \
    enable_simulation_progress_bar=true \
    experiment_uid="pluto_planner/$FILTER/last316_nr" \
    planner.pluto_planner.render=false \
    planner.pluto_planner.planner_ckpt="$CKPT_ROOT/$CKPT" \
    +planner.pluto_planner.save_dir=$VIDEO_SAVE_DIR


# Available options in 'scenario_filter':
#         all_scenarios
#         closed_loop_few_training_scenario
#         few_training_scenarios
#         mini_demo_scenario
#         nuplan_challenge_scenarios
#         one_continuous_log
#         one_hand_picked_scenario
#         one_of_each_scenario_type
#         one_percent_of_lv_strip_scenarios
#         random14_benchmark
#         simulation_test_split
#         training_scenarios
#         training_scenarios_1M
#         training_scenarios_tiny
#         val14_benchmark
#         val_demo_scenario

