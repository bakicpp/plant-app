# PlantApp

Bu uygulama, kullanıcılara bitki türleri eklemelerine, temaları değiştirmelerine  ve oturum açmalarına olanak tanıyan bir mobil uygulamadır.

## Özellikler

### Bitki Türü Ekleme

Uygulama içinde bitki türü eklemek için Firebase Storage kullanılır. Her bitki türü, adı, resmi ve rengi ile birlikte depolanır.

### Bitki Silme

Kullanıcı, bitki kutularının üzerinde bulunan ikona dokunarak bitki silme işlemini gerçekleştirebilir.

### Bitki Detayları

Kullanıcı, bitki kutularının üzeriine dokunarak bitkinin detaylarını açılan bir bottomsheet içerisinde görebilir.

### Ayarlar

Kullanıcı, uygulamanın sol üst köşesindeki drawer ikonuna dokunarak açılan drawer'da uygulamanın temasını ve dilini değiştirebilir; isterse hesabından çıkış yapabilir.

### Firebase Auth

Temel Firebase Authentication (Auth) işlevselliği eklenmiştir. Kullanıcılar giriş yapabilir ve kayıt olabilir. Kullanıcı daha önce giriş yapmışsa yeniden giriş yapmasına gerek kalmaz.

### Dinamik Tema Desteği

Kullanıcılar, uygulamanın genel temasını dinamik olarak değiştirebilirler. (Light / Dark)

### State Management ve BLoC

BLoC (Business Logic Component) kullanılarak, uygulama içindeki durum etkili bir şekilde yönetilir.

### Repository Provider

Veri sağlama ve işleme görevleri, Repository Provider kullanılarak yönetilir.

### Local Manager

İnternet bağlantısı olmadığında kullanıcının akışa devam etmesi için liste, Hive ile saklanır.

### Localization Desteği

Uygulamanın dilini değiştirebilmek için localization (yerelleştirme) özelliği eklenmiştir.


