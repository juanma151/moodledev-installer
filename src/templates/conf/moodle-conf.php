<?php
// vim: filetype=php : tabstop=3 : shiftwidth=3 : noexpandtab :

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dirroot = '@SITE-ROOT@';

$CFG->dbtype    = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost    = '127.0.0.1';
$CFG->dbname    = '@DB-NAME@';
$CFG->dbuser    = '@DB-USER@';
$CFG->dbpass    = '@DB-PASS@';
$CFG->prefix    = '@DB-PREFIX@';
$CFG->dboptions = [
	'dbpersist' => false,
	'dbport'   => '',
	'dbsocket'=> '',
	'dbcollation' => 'utf8mb4_unicode_ci',
];

$CFG->wwwroot  = 'http://@SITE-SERVERNAME@:@SITE-PORT@';
$CFG->dataroot = '@BASE-DIR@/moodledata';

$CFG->directorypermissions = 0777;

require_once($CFG->dirroot . '/lib/setup.php');
