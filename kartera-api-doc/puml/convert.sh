for file in *.puml
do
  java -jar plantuml.jar $file
done
cp *.png ../docs/img