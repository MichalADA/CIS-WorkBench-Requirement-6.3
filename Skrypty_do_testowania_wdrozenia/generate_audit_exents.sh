#!/bin/bash

echo "=== Generowanie zdarzeń do monitorowania auditd ==="

# 1. Modyfikacja plików związanych z użytkownikami i grupami
echo "Dodawanie użytkownika testowego..."
sudo useradd testuser
sudo passwd -d testuser
sudo usermod -aG sudo testuser
sudo groupadd testgroup
sudo gpasswd -d testuser testgroup

# 2. Edycja pliku sudoers
echo "Modyfikacja pliku /etc/sudoers..."
echo "# Test entry" | sudo tee -a /etc/sudoers > /dev/null

# 3. Praca w katalogach tymczasowych
echo "Tworzenie i modyfikacja plików w /tmp i /var/tmp..."
echo "Test file" | sudo tee /tmp/testfile > /dev/null
sudo chmod 777 /tmp/testfile
sudo rm -f /tmp/testfile
echo "Test file" | sudo tee /var/tmp/testfile > /dev/null
sudo chmod 777 /var/tmp/testfile
sudo rm -f /var/tmp/testfile

# 4. Uruchamianie poleceń i procesów
echo "Uruchamianie poleceń i procesów..."
sudo ls /root
sudo whoami
sudo bash -c "echo 'Test command execution' > /dev/null"

# 5. Symulacja edycji krytycznych plików
echo "Symulacja edycji krytycznych plików systemowych..."

# Tworzymy tymczasowe kopie krytycznych plików
sudo cp /etc/passwd /tmp/passwd_test
sudo cp /etc/group /tmp/group_test
sudo cp /boot/grub2/grub.cfg /tmp/grub.cfg_test

# Wykonujemy modyfikacje na kopiach zamiast oryginalnych plików
echo "Dodanie testowej linii do pliku passwd_test..." | sudo tee -a /tmp/passwd_test > /dev/null
echo "Dodanie testowej linii do pliku group_test..." | sudo tee -a /tmp/group_test > /dev/null
echo "Dodanie testowej linii do pliku grub.cfg_test..." | sudo tee -a /tmp/grub.cfg_test > /dev/null

# Opcjonalnie usuwamy tymczasowe pliki po symulacji
sudo rm -f /tmp/passwd_test /tmp/group_test /tmp/grub.cfg_test


echo "=== Generowanie zdarzeń zakończone ==="
