# ***How to Use***


- Untuk frontend, wajib dibuat projek baru flutter secara terpisah dari master dan copy isi file lib ke path-to-project/lib (project flutter) dan replace pubservice.yaml.

- Program Backend ada didalam folder services/Backend/src

- Hardware perlu dijalankan di arduino (ESP 32)

## ***Note:***

- Fronted dapat langsung berjalan jika backend aktif.

- Tidak perlu menggunakan hardware karena frontend membaca data datai database, bukan langsung dari hardware

- Data dari hardware langsung disimpan didatabase oleh backend

- Antena GPS harus menambak langsung ke langit. Jika tidak, maka tidak terbaca atau nilai longitudinal dan latitude bernilai 0

- Belum bisa terhubung dengan API google maps, sehingga tidak bisa melihat peta (hanya koordinat saja)
