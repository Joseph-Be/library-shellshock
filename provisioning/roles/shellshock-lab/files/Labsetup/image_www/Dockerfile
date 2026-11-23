FROM handsonsecurity/seed-server:apache-php

COPY bash_shellshock /bin/
COPY vul.cgi getenv.cgi /usr/lib/cgi-bin/
COPY server_name.conf  /etc/apache2/sites-available
COPY flag-entrypoint.sh /usr/local/bin/flag-entrypoint.sh
RUN  chmod 755 /bin/bash_shellshock \
     && chmod 755 /usr/lib/cgi-bin/*.cgi \
     && chmod 755 /usr/local/bin/flag-entrypoint.sh \
     && a2ensite server_name.conf

# L'entrypoint écrit les flags de la sandbox (lisibles par www-data, hors racine web)
# puis lance Apache. Les flags ne s'obtiennent qu'en exécutant une commande sur le
# serveur via la vulnérabilité Shellshock.
CMD ["/usr/local/bin/flag-entrypoint.sh"]
