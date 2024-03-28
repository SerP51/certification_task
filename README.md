# Файлы
1. Jenkinsfile - pipeline-файл для Jenkins
2. *.tf - файлы Terraform
3. metadata.yml - метаданные для содания VM
4. key.json - ключ сервисного аккаунта YC
5. playbook.yml - playbook для Ansible
6. hostsAnsible - хосты, которые будут настроеныс помощью Ansible
7. Dockerfile - файл для сборки докера

# Инструкция по запуску в Yandex Cloud:
0.  Установить Jenkins на управляющий host
1. Установка CLI:
```bash 
   curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```
2. Получить токен по [ссылке](https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb)
3. Выполните команду для настройки вашего профиля CLI.

```bash
yc init 
```
4. Скачать дистрибутив Terraform с помощью git clone из https://github.com/dkgnim/terraform
5. Распаковать и положить terraform сюда /usr/bin
6. Добавить зеркало Terraform от Yandex: 
```bash
nano ~/.terraformrc
```
```bash
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
Так же скопировать файл в домашнюю папку пользователя jenkins, в моем случае в /var/lib/jenkins/
7.  Создать сервисный аккаунт и сгенерировать ключ, полученным файлом key.json заменить тот что в репозитории: 
```bash
yc iam key create --service-account-name <имя_сервисного_аккаунта> --output key.json
```
8.  Сгенерировать ssh ключи для пользователя jenkins 
```bash 
   su jenkins
```
```bash 
   ssh-keygen
```
9. Внести открытую часть ключа в metadata.yml вместо ***
10. В файле YC.tf заполнить cloud_id, folder_id.
11. Установить terraform plugin в Jenkins'e, настроить его в разделе Tools и дать имя terraform17 или изменить соответствующее имя в модуле tools файла Jenkinsfile 
12. Создать credentials типа User and Password для доступа к Dockerhub, поменять в Jenkinsfile в переменной DOCKERHUB_CREDENTIALS.
13. В Jenkinsfile все упоминания serp51/mywebbapp935ddd заменить на свои.
14. Для запуска из веб-интерфейса Jenkinks pipeline можно настроить на github.
