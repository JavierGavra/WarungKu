Setiap fitur akan memiliki foldernya masing-masing, ini menerapkan prinsi SoC 
(Separation of Concern) agar proses developement bisa dikelola dengan mudah
sehingga error dan bug dari salah satu fitur tidak akan memengaruhi fitur yang
lain.

Buat yang pertama kali nyoba flutter mungkin bisa buat tampilan saja & fungsi-fungsi
penting nya saja, JANGAN MEMPERSULIT HIDUP!!! gpp ngodingnya berantakan, toh ini
tugas vibe coding.

Buat ngetes halamannya langsung ganti [HelloWorldPage()] di file [main.dart]
dengan nama class halaman kalian, ex: [TransactionPage()].

kerjakan di branch masing-masing (sesuai nama), terus di push ke repo.
JANGAN PERNAH NGERJAIN DI BRANCH "main" Plisssss!!!

===================================================================================

Struktur folder example:

transaction/
 |-- models/
 |   |-- [berisi file class dari sebuah data]
 |   |-- Product.dart
 |
 |-- views/
     |--pages/
        |-- [berisi file halaman uang akan digunakan di masing-masing fitur]
        |-- transaction_page.dart
        |-- scan_barcode_page.dart