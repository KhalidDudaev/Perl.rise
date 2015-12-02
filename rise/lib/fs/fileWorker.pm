# file access and modify methods

{ package rise::lib::fs; use rise::core::object::namespace;   

    use FileHandle;
    use rise::lib::fs::pathWorker;

    { package rise::lib::fs::fileWorker; use rise::core::object::class;  

        my $fh; no warnings; sub fh ():lvalue; *fh = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fh') unless (caller eq 'rise::lib::fs::fileWorker' || caller =~ m/^rise::lib::fs::fileWorker\b/o); $fh }; use warnings;  $fh = new FileHandle;
        my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'path') unless (caller eq 'rise::lib::fs::fileWorker' || caller =~ m/^rise::lib::fs::fileWorker\b/o); $path }; use warnings;  $path = new rise::lib::fs::pathWorker;
        my $fhelper; no warnings; sub fhelper ():lvalue; *fhelper = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fhelper') unless (caller eq 'rise::lib::fs::fileWorker' || caller =~ m/^rise::lib::fs::fileWorker\b/o); $fhelper }; use warnings;  $fhelper = new rise::lib::fs::fileHelper;

        my $binmode; no warnings; sub binmode ():lvalue; *binmode = sub ():lvalue {  $binmode }; use warnings;  $binmode = 0;

        { package rise::lib::fs::fileWorker::cmd_sel; use rise::core::object::function; sub cmd_sel { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'cmd_sel') unless (caller eq 'rise::lib::fs::fileWorker' || caller =~ m/^rise::lib::fs::fileWorker\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $c; no warnings; local *c; sub c ():lvalue; *c = sub ():lvalue {  $c }; use warnings;  ($self,$c) = ($_[0],$_[1]); 
        	my $cmddp; no warnings; sub cmddp ():lvalue; *cmddp = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'cmddp') unless (caller eq 'rise::lib::fs::fileWorker::cmd_sel' || caller =~ m/^rise::lib::fs::fileWorker::cmd_sel\b/o); $cmddp }; use warnings;  $cmddp = {
                'read'					=> '<',
        	    'write'					=> '>',
        	    'append'				=> '>>'
            };
            return $cmddp->{$c};
        }};

        { package rise::lib::fs::fileWorker::file; use rise::core::object::function; sub  file {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $cmd; no warnings; local *cmd; sub cmd ():lvalue; *cmd = sub ():lvalue {  $cmd }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings; my $data; no warnings; local *data; sub data ():lvalue; *data = sub ():lvalue {  $data }; use warnings;  ($self,$cmd,$name,$data) = ($_[0],$_[1],$_[2],$_[3]);
            my $res; no warnings; sub res ():lvalue; *res = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'res') unless (caller eq 'rise::lib::fs::fileWorker::file' || caller =~ m/^rise::lib::fs::fileWorker::file\b/o); $res }; use warnings; 
        	$data = __RISE_JOIN('',<$data>) if ref $data eq 'Fh';
            $name = $self->cmd_sel($cmd) . $self->path->toAbs($name);

            # self.fh->open(name) || die "cannot open file $@";
            $self->fh->open($name);
            $self->fh->binmode() if $self->binmode;

            $res = __RISE_JOIN('', [$self->fh->getlines()])  if $cmd eq 'read';
            $res = $self->fh->write($data)           if $cmd eq 'write';
            $res = $self->fh->write($data)           if $cmd eq 'append';
            $self->fh->close;
            return $res;
        }}

        { package rise::lib::fs::fileWorker::read; use rise::core::object::function; sub  read {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings;  ($self,$name) = ($_[0],$_[1]); 
            return $self->file('read', $name);
        }}

        { package rise::lib::fs::fileWorker::write; use rise::core::object::function; sub  write {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings; my $data; no warnings; local *data; sub data ():lvalue; *data = sub ():lvalue {  $data }; use warnings;  ($self,$name,$data) = ($_[0],$_[1],$_[2]); 
            return $self->file('write', $name, $data);
        }}

        { package rise::lib::fs::fileWorker::append; use rise::core::object::function; sub  append {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings; my $data; no warnings; local *data; sub data ():lvalue; *data = sub ():lvalue {  $data }; use warnings;  ($self,$name,$data) = ($_[0],$_[1],$_[2]);
            return $self->file('append', $name, $data);
        }}

        { package rise::lib::fs::fileWorker::copy; use rise::core::object::function; sub  copy {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name1; no warnings; local *name1; sub name1 ():lvalue; *name1 = sub ():lvalue {  $name1 }; use warnings; my $name2; no warnings; local *name2; sub name2 ():lvalue; *name2 = sub ():lvalue {  $name2 }; use warnings;  ($self,$name1,$name2) = ($_[0],$_[1],$_[2]);
            return $self->fhelper->fcopy($name1, $name2);
        }}

        { package rise::lib::fs::fileWorker::move; use rise::core::object::function; sub  move {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name_old; no warnings; local *name_old; sub name_old ():lvalue; *name_old = sub ():lvalue {  $name_old }; use warnings; my $name_new; no warnings; local *name_new; sub name_new ():lvalue; *name_new = sub ():lvalue {  $name_new }; use warnings;  ($self,$name_old,$name_new) = ($_[0],$_[1],$_[2]);
            return $self->fhelper->fmove($name_old, $name_new);
        }}

        { package rise::lib::fs::fileWorker::delete; use rise::core::object::function; sub  delete {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);
            unlink $name;
        }}

    }

    { package rise::lib::fs::fileHelper; use rise::core::object::class;  
        use File::Copy;

        { package rise::lib::fs::fileHelper::fcopy; use rise::core::object::function; sub  fcopy {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name1; no warnings; local *name1; sub name1 ():lvalue; *name1 = sub ():lvalue {  $name1 }; use warnings; my $name2; no warnings; local *name2; sub name2 ():lvalue; *name2 = sub ():lvalue {  $name2 }; use warnings;  ($self,$name1,$name2) = ($_[0],$_[1],$_[2]);
            return File::Copy::copy($name1, $name2);
        }}

        { package rise::lib::fs::fileHelper::fmove; use rise::core::object::function; sub  fmove {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name_old; no warnings; local *name_old; sub name_old ():lvalue; *name_old = sub ():lvalue {  $name_old }; use warnings; my $name_new; no warnings; local *name_new; sub name_new ():lvalue; *name_new = sub ():lvalue {  $name_new }; use warnings;  ($self,$name_old,$name_new) = ($_[0],$_[1],$_[2]);
            return File::Copy::move($name_old, $name_new);
        }}
    }
}

1;