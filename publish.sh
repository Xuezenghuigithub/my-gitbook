echo "Start Publish🏃"
book sm
gitbook build . docs
cp ./CNAME ./docs/
echo "Build Success!🎉"
git add .
git commit -m "feat: update note"
git push
git co gh-pages
git merge master
git push
git co master
echo "Publish Success!🎉🎉🎉"