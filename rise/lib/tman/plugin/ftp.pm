use rise::lib::ftp;

{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::ftp; use rise::core::object::class;  

		{ package rise::lib::tman::plugin::ftp::ftp; use rise::core::object::function; sub ftp {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $conf; no warnings; local *conf; sub conf ():lvalue; *conf = sub ():lvalue {  $conf }; use warnings;  ($self,$conf) = ($_[0],$_[1]); 
			# if (self.src_name){
				my $ftppath; no warnings; sub ftppath ():lvalue; *ftppath = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'ftppath') unless (caller eq 'rise::lib::tman::plugin::ftp::ftp' || caller =~ m/^rise::lib::tman::plugin::ftp::ftp\b/o); $ftppath }; use warnings;  $ftppath = $conf->{path} . '/' . $self->referPath();
				my $ftppath_full; no warnings; sub ftppath_full ():lvalue; *ftppath_full = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'ftppath_full') unless (caller eq 'rise::lib::tman::plugin::ftp::ftp' || caller =~ m/^rise::lib::tman::plugin::ftp::ftp\b/o); $ftppath_full }; use warnings;  $ftppath_full = $ftppath . $self->filename;
				my $ftpw; no warnings; sub ftpw ():lvalue; *ftpw = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'ftpw') unless (caller eq 'rise::lib::tman::plugin::ftp::ftp' || caller =~ m/^rise::lib::tman::plugin::ftp::ftp\b/o); $ftpw }; use warnings;  $ftpw = rise::lib::ftp->new ($conf->{host}, Timeout => 100, Debug => 0 ) || die "Can't connect to ftp server.\n";

				$self->dst_file		= $self->filename;
				$self->ref_path		= $self->referPath();

				$ftpw->login($conf->{user}, $conf->{pass});
				# ftpw.cwd('/');

				if(!$ftpw->cwd($ftppath)){
					$ftpw->mkdir($ftppath, 1);
					# say "make remote dir -> $ftppath";
				}

				# say ">>> host   -> " ~ conf.{host};
				# say ">>> user   -> " ~ conf.{user};
				# say ">>> pass   -> " ~ conf.{pass};
				# say ">>> path   -> " ~ conf.{path};

				# self.fs.file.write(self.src_name, ftppath_full) if ftppath_full;
				# ftpw.cwd(ftppath);
				$ftpw->put($self->src_name, $ftppath_full);
				# say "file put to FTP -> $ftppath_full";
				$self->sndOK();
			# }
			return $self;
		}}
	}
}

1;