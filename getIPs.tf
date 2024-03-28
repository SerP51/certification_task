output buildingVM_IP {
  value = yandex_compute_instance.building-vm.network_interface.0.nat_ip_address
}
output prodVM_IP {
  value = yandex_compute_instance.prod-vm.network_interface.0.nat_ip_address
}
