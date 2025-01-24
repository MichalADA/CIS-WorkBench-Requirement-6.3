# Plan wdrożenia systemu monitoringu uprawnień (CIS WorkBench Requirement 6.3)

## **Opis projektu**
Projekt pokazuje implementację systemu monitoringu uprawnień i dostępu zgodnie z wymaganiami **CIS WorkBench Requirement 6.3**. Celem projektu jest zbudowanie systemu, który umożliwi ciągły audyt i monitorowanie uprawnień użytkowników oraz dostępu do systemów.

---

## **Monitoring uprawnień i dostępu (CIS WorkBench Requirement 6.3)**
### **Cel wymagania:**
- Ciągły monitoring i audyt uprawnień użytkowników oraz dostępu do systemów.

### **Kluczowe elementy:**
1. **Śledzenie zmian w uprawnieniach:**
   - Monitorowanie plików systemowych odpowiedzialnych za użytkowników, grupy oraz uprawnienia.
2. **Wykrywanie anomalii w dostępie:**
   - Rejestracja nietypowych operacji użytkowników i administratorów.
3. **Raportowanie naruszeń polityk:**
   - Generowanie raportów na podstawie zebranych logów.
4. **Automatyczne powiadomienia o zmianach:**
   - Powiadomienia o krytycznych zdarzeniach dotyczących zmian w systemie.

---

## **Reguły wdrożone w `auditd`**

### **Flagi i ich znaczenie**
- **`-w`**: Ustawienie monitorowania dla konkretnego pliku lub katalogu.
- **`-p`**: Określenie, jakie typy zdarzeń mają być monitorowane:
  - **`r`**: Odczyt pliku.
  - **`w`**: Zapis/edycja pliku.
  - **`x`**: Wykonanie pliku.
  - **`a`**: Zmiana atrybutów pliku (np. zmiana uprawnień).
- **`-k`**: Ustawienie klucza identyfikującego regułę. Klucz pozwala na łatwe filtrowanie zdarzeń w logach.
- **`-a always,exit`**: Monitorowanie wszystkich zdarzeń wyjścia z określonych syscalls (np. `execve`).
- **`-F`**: Dodanie warunku do reguły, np. filtrowanie po użytkowniku, syscall lub architekturze.
- **`arch=b64`**: Określenie architektury 64-bitowej (x86_64).
- **`-S`**: Określenie syscall, który ma być monitorowany (np. `execve`).

### **1. Monitorowanie zmian w uprawnieniach**
- Śledzenie zmian w plikach systemowych odpowiedzialnych za użytkowników i grupy:
  ```bash
  -w /etc/passwd -p wa -k passwd_changes
  -w /etc/shadow -p wa -k shadow_changes
  -w /etc/group -p wa -k group_changes
  -w /etc/gshadow -p wa -k gshadow_changes
  ```

### **2. Monitorowanie logowania i działań użytkowników**
- Rejestracja logowań oraz nieudanych prób:
  ```bash
  -w /var/log/wtmp -p wa -k logins
  -w /var/log/btmp -p wa -k failed_logins
  -w /var/log/lastlog -p wa -k lastlog_changes
  ```

### **3. Monitorowanie działań administracyjnych (sudo)**
- Śledzenie zmian w plikach konfiguracji `sudo`:
  ```bash
  -w /etc/sudoers -p wa -k sudoers_changes
  -w /etc/sudoers.d/ -p wa -k sudoers_d_changes
  ```
- Rejestracja poleceń wykonanych z uprawnieniami `sudo`:
  ```bash
  -a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k sudo_exec
  ```

### **4. Monitorowanie zmian w konfiguracji systemu**
- Zmiany w konfiguracji systemu oraz politykach bezpieczeństwa:
  ```bash
  -w /etc/login.defs -p wa -k login_defs_changes
  -w /etc/ssh/sshd_config -p wa -k ssh_config_changes
  -w /etc/pam.d/ -p wa -k pam_changes
  ```

### **5. Monitorowanie katalogów tymczasowych**
- Rejestracja działań na katalogach tymczasowych:
  ```bash
  -w /tmp/ -p rwxa -k tmp_access
  -w /var/tmp/ -p rwxa -k var_tmp_access
  ```

### **6. Monitorowanie uruchamianych poleceń**
- Rejestracja wszystkich uruchamianych komend:
  ```bash
  -a always,exit -F arch=b64 -S execve -k command_exec
  ```

### **7. Monitorowanie zmian w krytycznych plikach systemowych**
- Śledzenie zmian w pliku konfiguracji bootloadera:
  ```bash
  -w /boot/grub2/grub.cfg -p wa -k grub_config_changes
  ```

---

## **Skrypty wspierające**

### **Generowanie raportów**
Przykładowy skrypt do generowania raportów z logów auditd:

```bash
#!/bin/bash

REPORT_DIR="/var/reports"
mkdir -p $REPORT_DIR
DATE=$(date +"%Y-%m-%d")

grep "passwd_changes" /var/log/audit/audit.log > $REPORT_DIR/passwd_changes_$DATE.log
grep "sudoers_changes" /var/log/audit/audit.log > $REPORT_DIR/sudoers_changes_$DATE.log
grep "sudo_exec" /var/log/audit/audit.log > $REPORT_DIR/sudo_exec_$DATE.log
grep "logins" /var/log/audit/audit.log > $REPORT_DIR/logins_$DATE.log

echo "Raporty zostały zapisane w $REPORT_DIR"
```

---

## **Plan na przyszłość**
1. Rozszerzenie konfiguracji `auditd` o dodatkowe reguły.
2. Stworzenie testów automatycznych, które zaprezentują wyniki monitoringu w przystępnej formie.
3. Przygotowanie skryptów do analizy logów i generowania zaawansowanych raportów.
4. Prezentacja wyników w czytelny i wizualny sposób.
