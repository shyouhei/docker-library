This is not a Dockerfile.  Rather it utilises systemd-nspawn.

The reason behind this is discourse script/bench.rb _mandates_ both redis and postgres be listening (= running) at localhost.  This is not a normal setup for docker container.  A docker container cannot run systemd service.  I tried writing docker-compose.yml to reroute this by using multiple containers, but ended up giving up.  With systemd-nspawn no such restriction exist.

Run `bash debootstrap.sh` to boot a container.
Login as shyouhei and run `DISCOURSE_RBENV=x.y.z bash /var/discourse/entrypoint.sh`.

Once you have finished, run `sudo systemctl poweroff`.
