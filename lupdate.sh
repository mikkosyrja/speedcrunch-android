lupdate -locations none qml -ts locale/mobile.ts
if [ $? -ne 0 ]; then
	lupdate-qt5 -locations none qml -ts locale/mobile.ts
fi
