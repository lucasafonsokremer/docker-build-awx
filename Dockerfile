# Versao do awx a ser utilizada como base
FROM ansible/awx:14.1.0

# Definir aqui a versao do pip, casando com a da plataforma para ser utilizada na criacao dos virtual env
ENV VERSAOAWXPIP=19.3.1

# Labels para identificar o responsavel destes containers
LABEL author="Lucas Afonso Kremer"
LABEL email="lucasafonsokremer@gmail.com"

# Usuario atualmente configurado no projeto oficial
USER root

# Copia o diretorio com as libs a serem instaladas nos venvs
# Respeitar a tag das imagens e colocar o nome dos arquivos neste padrao
ADD Dockerfile_requirements /tmp/Dockerfile_requirements

# Instala o zabbix-sender, libcurl-devel e gcc para compilar algumas libs em python
RUN yum install -y http://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-sender-5.0.0-1.el8.x86_64.rpm gcc libcurl-devel ; \
    yum clean all

# Cria o diretorio base dos venvs custom, por padrao seguir a tag da versao do AWX 
RUN for virtualenvs in $(ls -1 /tmp/Dockerfile_requirements/) ; \
    do \
        mkdir -p /opt/custom_venv/${virtualenvs} ; \
        chmod -R 0755 /opt/custom_venv ; \
    done

# Cria o novo venv sem o pip para selecionar uma versao especifica depois
# Cria os venvs com visao nas libs globais do python que sao instaladas via gerenciador de pacotes
RUN for virtualenvs in $(ls -1 /tmp/Dockerfile_requirements/) ; \
    do \
        virtualenv --no-pip --system-site-packages /opt/custom_venv/${virtualenvs} ; \
    done

# Ativa o venv e instala todas as bibliotecas que o custom necessita
# Instala uma versao especifica para o pip
RUN for virtualenvs in $(ls -1 /tmp/Dockerfile_requirements/) ; \ 
    do \
    sh -c "source /opt/custom_venv/${virtualenvs}/bin/activate ; \
           curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py ; \
           python get-pip.py pip==${VERSAOAWXPIP} ; \
           pip install -r /tmp/Dockerfile_requirements/${virtualenvs} ; \
           deactivate" ; \
    done
