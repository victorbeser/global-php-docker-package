====================CONFIG=====================
sudo nano /etc/httpd/conf.d/legado-[NOME-SISTEMA].conf

====================CONTEUDO=====================
# ==========================================
# SISTEMA LEGADO - [NOME-SISTEMA]
# PHP 5.3/7.1 - Docker
# ==========================================

<IfModule mod_proxy.c>

    # URL publica:
    # /legado/snas/[NOME-SISTEMA]/
    #
    # Docker:
    # http://127.0.0.1:8080/snas/[NOME-SISTEMA]/

    RedirectMatch 301 ^/legado/snas/[NOME-SISTEMA]$ /legado/snas/[NOME-SISTEMA]/

    ProxyPass        "/legado/snas/[NOME-SISTEMA]/" "http://127.0.0.1:8080/snas/[NOME-SISTEMA]/"
    ProxyPassReverse "/legado/snas/[NOME-SISTEMA]/" "http://127.0.0.1:8080/snas/[NOME-SISTEMA]/"

</IfModule>

====================VALIDAÇÃO=====================
Validação:
sudo httpd -t

====================RESTART=====================
Restart:
sudo systemctl restart httpd

====================TESTE=====================
Teste:
curl -I -H "Host: redesuas.mds.gov.br" http://127.0.0.1/legado/snas/[NOME-SISTEMA]/
