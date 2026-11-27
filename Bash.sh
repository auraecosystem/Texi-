make all && make clean
make all
git init
git add .
git commit -m "Initial Texinfo manual scaffold"
mkdir gcc-build && cd gcc-build
../gcc/configure --disable-bootstrap --enable-languages=c
cp -r my-manual/* .
rm -rf my-manual docs main.texi Bash.sh
make all
git add -A
git commit -m "Consolidate Texinfo directory structure"
git push origin main
