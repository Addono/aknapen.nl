rmdir .\production /s /q
mkdir .\production
echo gitdir: ../.git/modules/production> .\production\.git

hugo -d .\production\

cd .\production\
git add *
git commit -a -m "push updated build"
git push
cd ../