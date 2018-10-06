lrelease -idbased locale/mobile.*.ts
if [ $? -ne 0 ]; then
	lrelease-qt5 -idbased locale/mobile.*.ts
fi
