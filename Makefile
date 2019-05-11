all:
	./build-vm -d --name w4mdev-qwerty  --show --wait --halt
	./build-vm -d --name w4mprod-qwerty --show --wait --halt --prod
	./build-vm -d --name w4mdev-azerty  --show --wait --halt --azerty
	./build-vm -d --name w4mprod-azerty --show --wait --halt --prod --azerty

clean:
	for vm in .vagrant/machines/* ; do W4MVM_NAME=$$(basename $$vm) vagrant destroy -f $$(basename $$vm) ; done

.PHONY: all clean
