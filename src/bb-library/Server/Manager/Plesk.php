<?php
#!/usr/bin/env php
// Copyright 1999-2016. Parallels IP Holdings GmbH. All Rights Reserved.
require_once('PleskApiClient.php');
class PleskApiClient{public static function getForm()
    {
        return array(
            'label'     =>  'Plesk',
        );
    }
private function _request($request) {
$host = getenv('REMOTE_HOST');
$login = getenv('REMOTE_LOGIN') ?: 'admin';
$password = getenv('REMOTE_PASSWORD');
$client = new PleskApiClient($host);
$client->setCredentials($login, $password);
$request = <<<EOF
<packet>
  <server>
    <get_protos/>
  </server>
</packet>
EOF;
$response = $client->request($request);
echo $response;}
}
