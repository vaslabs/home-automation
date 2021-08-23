function find_gamepad_instance() {
    tx_file=$1
    aws ec2 describe-instances --filters "Name=tag:purpose, Values=gamepads" >$tx_file
}

function is_running() {
    tx_file=$1
    status=$(cat $tx_file | jq -r '.Reservations[].Instances[].State.Name')
    [ "$status" = "running" ]
}

function gamepads_are_running() {
    tx_file=$(mktemp)
    find_gamepad_instance $tx_file
    is_running $tx_file
}

function instance_id() {
    tx_file=$(mktemp)
    find_gamepad_instance $tx_file
    cat $tx_file | jq -r '.Reservations[].Instances[].InstanceId'
}

function spin_up_gamepad_instance() {
    aws ec2 run-instances --launch-template LaunchTemplateName=gamepads --dry-run
}

function run_gameped_instance() {
    instance_id=$1
    aws ec2 start-instances --instance-ids $instance_id
    wait_for_instance_state $instance_id running
}

function wait_for_instance_state() {
    instance_id=$1
    expected_state=$2
    wait_max=5
    if [ -n "$3" ]; then
        wait_max=$3
    fi
    current_state=$(aws ec2 describe-instances --instance-ids $instance_id | jq -r '.Reservations[].Instances[].State.Name')
    if [ "$expected_state" = "$current_state" ]; then
        echo "$instance_id has reached $current_state"
    else
        sleep 10
        wait_for_instance_state $instance_id $expected_state
    fi
}