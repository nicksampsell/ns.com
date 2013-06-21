exec { 'apt-get update':
  command => '/usr/bin/apt-get update'
}

file { '/home/vagrant/public_html':
	ensure => directory
}

file { '/home/vagrant/public_html/dev.nicksampsell.com':
	ensure => directory,
	recurse => true,
	require => File['/home/vagrant/public_html']
}

file { '/home/vagrant/logs':
	ensure => directory
}

file { '/home/vagrant/logs/dev.nicksampsell.com':
	ensure => directory,
	recurse => true,
	require => File['/home/vagrant/logs']
}

package { 'apache2':
	ensure => present,
	before => File['/etc/apache2/apache2.conf'],
	require => [File['/home/vagrant/public_html/dev.nicksampsell.com'],
				Exec['apt-get update']]
}

file { '/etc/apache2/apache2.conf':
	ensure => file,
	source => '/home/vagrant/.puppet/static/apache2.conf'
}
file { '/etc/apache2/sites-enabled/default':
	ensure => absent,
}
file { '/etc/apache2/sites-available/dev.nicksampsell.com':
	ensure => file,
	source => '/home/vagrant/.puppet/static/site.conf',
	require => Package['apache2']
}

file { '/etc/apache2/sites-enabled/dev.nicksampsell.com':
	ensure => link,
	target => '/etc/apache2/sites-available/dev.nicksampsell.com',
	require => File['/etc/apache2/sites-available/dev.nicksampsell.com'],
	notify => Service['apache2']
}

service { 'apache2':
	ensure => running,
	enable => true,
	subscribe => File['/etc/apache2/apache2.conf']
}

package { 'mysql-server':
	ensure => present,
	before => File['/etc/mysql/my.cnf']
}
file { '/etc/mysql/my.cnf':
	ensure => file,
	source => '/home/vagrant/.puppet/static/my.cnf'
}

service { 'mysql':
	ensure => running,
	enable => true,
	subscribe => File['/etc/mysql/my.cnf'],
	require => Package['mysql-server']
}

package { 'php5':
	ensure => present,
	require => Package['apache2'],
	notify => Service['apache2']
}

file { '/etc/php5/apache2/php.ini':
	ensure => file,
	source => '/home/vagrant/.puppet/static/php.ini',
	require => Package['php5']
}

package { 'php-pear':
	ensure => present,
	require => Package['php5'],
	notify => Service['apache2']
}


package { 'php5-mysql':
	ensure => present,
	require => Package['php5'],
	notify => Service['apache2']
}