#!/bin/bash

# Verificar si se proporcionan los argumentos necesarios
if [ $# -ne 7 ]; then
    echo "Uso: $0 <nombre_vm> <tipo_sistema_operativo> <num_cpus> <memoria_ram_GB> <vram_MB> <tamanio_disco_GB> <nombre_controlador_sata>"
    exit 1
fi

# Capturar los argumentos
nombre_vm=$1
tipo_so=$2
num_cpus=$3
memoria_ram=$4
vram=$5
tamanio_disco=$6
nombre_controlador_sata=$7

# Crear la máquina virtual
VBoxManage createvm --name "$nombre_vm" --ostype "$tipo_so" --register

# Configurar la máquina virtual
VBoxManage modifyvm "$nombre_vm" --cpus "$num_cpus"
VBoxManage modifyvm "$nombre_vm" --memory "$memoria_ram" --vram "$vram"

# Crear el disco duro virtual
VBoxManage createhd --filename "$nombre_vm.vdi" --size "$tamanio_disco"

# Asociar el disco duro virtual a la máquina virtual
VBoxManage storagectl "$nombre_vm" --name "$nombre_controlador_sata" --add sata
VBoxManage storageattach "$nombre_vm" --storagectl "$nombre_controlador_sata" --port 0 --device 0 --type hdd --medium "$nombre_vm.vdi"

# Crear el controlador IDE para CD/DVD
VBoxManage storagectl "$nombre_vm" --name "IDE Controller" --add ide

# Imprimir la configuración
echo "Configuración creada y configurada:"
echo "Nombre de la VM: $nombre_vm"
echo "Tipo de SO: $tipo_so"
echo "Número de CPUs: $num_cpus"
echo "Memoria RAM: $memoria_ram GB"
echo "VRAM: $vram MB"
echo "Tamaño del disco duro virtual: $tamanio_disco GB"
echo "Nombre del controlador SATA: $nombre_controlador_sata"
