# remove old files
rm -r tmp
mkdir tmp
mkdir tmp/images

# 50 images is fast, 200 is quite slow
#ffmpeg -i videos/drone-fullpan.mov -r 5 -qscale 3 tmp/images/image-%3d.jpg
#ffmpeg -i videos/drone-fullpan.mov -r 5 -qscale 3 -filter:v "crop=720:720:280:0" tmp/images/image-%3d.jpg
ffmpeg -i videos/drone-fullpan.mov -r 5 -qscale 3 -filter:v "crop=1000:720:140:0" tmp/images/image-%3d.jpg

#pto_gen -f 60 -o tmp/hugin.pto tmp/images/*.jpg
pto_gen -o tmp/hugin.pto tmp/images/*.jpg

cpfind --multirow -o tmp/hugin.pto tmp/hugin.pto
#cpfind -o tmp/hugin.pto tmp/hugin.pto

cpclean -o tmp/hugin.pto tmp/hugin.pto
#ptoclean -v --output tmp/hugin.pto tmp/hugin.pto

linefind -o tmp/hugin.pto tmp/hugin.pto

autooptimiser -a -l -s -m -o tmp/hugin.pto tmp/hugin.pto

#autooptimiser -a -l -s -m -o tmp/hugin.pto tmp/hugin.pto
#pano_modify -o tmp/hugin.pto --center --straighten --canvas=AUTO --crop=AUTO tmp/hugin.pto

#pano_modify -o tmp/hugin.pto --center --canvas=AUTO tmp/hugin.pto
#pano_modify -o tmp/hugin.pto --center --canvas=200% tmp/hugin.pto
#pano_modify -o tmp/hugin.pto --center --fov=AUTO --canvas=40% tmp/hugin.pto
pano_modify -o tmp/hugin.pto --center --fov=AUTO --canvas=70% tmp/hugin.pto

pto2mk -o tmp/hugin.mk -p tmp/output tmp/hugin.pto

sed -e s/enblend/enfuse/g tmp/hugin.mk > tmp/hugin-fix-tmp1.mk

#sed -e s/ENBLEND_OPTS\=/ENBLEND_OPTS\=--exposure-weight\=0.1\ --saturation-weight\=0.1\ --contrast-window-size\=21\ --contrast-weight\=1.0\ --hard-mask\ \#/g tmp/hugin-fix-tmp1.mk > tmp/hugin-fix-tmp2.mk
sed -e s/ENBLEND_OPTS\=/ENBLEND_OPTS\=--exposure-weight\=0.1\ --saturation-weight\=0.1\ --gray-projector\=l-star\ --contrast-edge-scale\=0.3\ --contrast-weight\=1.0\ --hard-mask\ \#/g tmp/hugin-fix-tmp1.mk > tmp/hugin-fix-tmp2.mk
#sed -e s/ENBLEND_OPTS\=/ENBLEND_OPTS\=\#/g tmp/hugin-fix-tmp1.mk > tmp/hugin-fix-tmp2.mk

sed -e s/ENBLEND_LDR_COMP\=/ENBLEND_LDR_COMP\=\#/g tmp/hugin-fix-tmp2.mk > tmp/hugin-fix-tmp3.mk
sed -e s/ENBLEND_EXPOSURE_COMP\=/ENBLEND_EXPOSURE_COMP\=\#/g tmp/hugin-fix-tmp3.mk > tmp/hugin-fix.mk
rm tmp/hugin-fix-tmp*.mk

make -f tmp/hugin-fix.mk all
