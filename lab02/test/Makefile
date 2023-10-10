.PHONY:test,clean
test:
	arm-linux-gnueabihf-gcc main.s -o main
	qemu-arm -L /usr/arm-linux-gnueabihf ./main
clean:
	rm -fr main
