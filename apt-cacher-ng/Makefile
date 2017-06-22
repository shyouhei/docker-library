
# zsh for $var:l transform
SHELL=/bin/zsh

ubuntu_mirrors: mirrors archivemirrors aws
	pcregrep -o1 '<a href="(.+?)">http</a>' archivemirrors >> ubuntu_mirrors
	cat mirrors aws >> ubuntu_mirrors

PHONY: clean

mirrors:
	wget --mirror http://mirrors.ubuntu.com
	cd mirrors.ubuntu.com; \
	for i in ??.txt; \
	do \
	  echo $$i; \
	  echo "$$i:l" | sed s,^,http://, | sed s,.txt,.archive.ubuntu.com/ubuntu/, >> ../mirrors; \
	  cat $$i >> ../mirrors; \
	  echo >> ../mirrors; \
	done

archivemirrors:
	wget -O archivemirrors 'https://launchpad.net/ubuntu/+archivemirrors' 

aws:
	for i in us-east-1 us-east-2 us-west-1 us-west-2 ca-central-1 \
	  eu-west-1 eu-west-2 eu-central-1 \
	  ap-northeast-1 ap-northeast-2 ap-southeast-1 ap-southeast-2 \
	  ap-south-1 sa-east-1; \
	do \
	  echo http://$$i.ec2.archive.ubuntu.com/ubuntu/ >> aws; \
	done

clean:
	rm -rf archivemirrors mirrors.ubuntu.com
