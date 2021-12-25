function no_wayland() {
    sed -i 's/#WaylandEnable=false/WaylandEnable=false/g' $1
}

function wayland() {
    sed -i 's/WaylandEnable=false/#WaylandEnable=false/g' $1
}

wayland=$1

function find_gdm_file() {
    if [[ -z "$TEST_FILE" ]]; then
        gdm_custom_conf="/etc/gdm/custom.conf"
    else
        gdm_custom_conf="$TEST_FILE"
    fi
    [ -f "$gdm_custom_conf" ] && echo "$gdm_custom_conf" || exit 0 # no autologin, user makes choice
}

if [[ "$wayland" == "yes" ]]; then
    wayland "$(find_gdm_file)"
else
    no_wayland "$(find_gdm_file)"
fi