#!/usr/bin/qemu-arm-static /bin/sh

mv /bin/sh /bin/sh.real
cp /usr/bin/sh-shim /bin/sh

set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
exec "$@"

mv /bin/sh.real /bin/sh
