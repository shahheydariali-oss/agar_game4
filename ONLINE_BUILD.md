# ساخت APK آنلاین برای «اگر...»

## روش پیشنهادی: GitHub Actions

1. کل پروژه را داخل یک Repository در GitHub آپلود کنید.
2. نام Repository می‌تواند `agar-game` باشد.
3. از تب **Actions** وارد workflow با نام **Build Android APK** شوید.
4. روی **Run workflow** بزنید.
5. پس از پایان Build، در بخش **Artifacts** فایل `agar-game-release-apk` را دریافت کنید.
6. فایل `app-release.apk` را روی گوشی اندروید نصب کنید.

این پروژه برای اینکه پوشه `android/` لازم نباشد داخل ZIP نگهداری شود، هنگام Build به‌صورت خودکار با `flutter create --platforms=android .` فایل‌های Android را تولید می‌کند.

## روش جایگزین: Codemagic

فایل `codemagic.yaml` هم آماده است. پروژه را به Codemagic متصل کنید و workflow با نام **اگر... Android APK** را اجرا کنید. خروجی APK در Artifacts قرار می‌گیرد.

## نکته مهم

این نسخه یک Prototype قابل Build است؛ 300 مرحله در ساختار داده تعریف شده‌اند، اما همه 300 مرحله هنوز محتوای روایی کامل و شاخه‌های نهایی ندارند. بعد از گرفتن APK می‌توانیم محتوا و موتور بازی را مرحله‌به‌مرحله کامل کنیم.
