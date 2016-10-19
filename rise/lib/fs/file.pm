# file access and modify methods

{ package rise::lib::fs; use rise::core::object::namespace;   

    use FileHandle;
    use rise::lib::fs::path;

    { package rise::lib::fs::file; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1018013856"; sub VERSION {"2016.1018013856"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{private-function-cmd_sel  public-function-file  public-function-read  public-function-write  public-function-append  public-function-copy  public-function-move  public-function-delete  private-var-fh  private-var-path  private-var-fhelper  public-var-binmod}} 

         sub fh ():lvalue; no warnings; *__fh__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fh') unless (caller eq 'rise::lib::fs::file' || caller =~ m/^rise::lib::fs::file\b/o); my $self = shift; $self->{'fh'} }; *fh = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fh') unless (caller eq 'rise::lib::fs::file' || caller =~ m/^rise::lib::fs::file\b/o); $__RISE_SELF__->{'fh'} }; use warnings;  fh = new FileHandle::;
         sub path ():lvalue; no warnings; *__path__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'path') unless (caller eq 'rise::lib::fs::file' || caller =~ m/^rise::lib::fs::file\b/o); my $self = shift; $self->{'path'} }; *path = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'path') unless (caller eq 'rise::lib::fs::file' || caller =~ m/^rise::lib::fs::file\b/o); $__RISE_SELF__->{'path'} }; use warnings;  path = new rise::lib::fs::path::;
         sub fhelper ():lvalue; no warnings; *__fhelper__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fhelper') unless (caller eq 'rise::lib::fs::file' || caller =~ m/^rise::lib::fs::file\b/o); my $self = shift; $self->{'fhelper'} }; *fhelper = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fhelper') unless (caller eq 'rise::lib::fs::file' || caller =~ m/^rise::lib::fs::file\b/o); $__RISE_SELF__->{'fhelper'} }; use warnings;  fhelper = new rise::lib::fs::fileHelper::;

         sub binmod ():lvalue; no warnings; *__binmod__ = sub ():lvalue {  my $self = shift; $self->{'binmod'} }; *binmod = sub ():lvalue {  $__RISE_SELF__->{'binmod'} }; use warnings;  binmod = 0;

        { package rise::lib::fs::file::cmd_sel; use rise::core::object::function; sub cmd_sel { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'cmd_sel') unless (caller eq 'rise::lib::fs::file' || caller =~ m/^rise::lib::fs::file\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $c; no warnings; sub c ():lvalue; *c = sub ():lvalue { $c }; use warnings;  ($self,$c) = ($_[0],$_[1]); 
        	my $cmddp; no warnings; sub cmddp ():lvalue; *cmddp = sub ():lvalue { $cmddp }; use warnings;  $cmddp = {
                'read'					=> '<',
        	    'write'					=> '>',
        	    'append'				=> '>>'
            };
            return $cmddp->{$c};
        }};

        { package rise::lib::fs::file::file; use rise::core::object::function;  sub file {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $cmd; no warnings; sub cmd ():lvalue; *cmd = sub ():lvalue { $cmd }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$cmd,$name,$data) = ($_[0],$_[1],$_[2],$_[3]);
            my $res; no warnings; sub res ():lvalue; *res = sub ():lvalue { $res }; use warnings; 
            $name = $self->cmd_sel($cmd) . $self->path->toAbs($name);
        	$data = __RISE_JOIN('',<$data>) if ref $data eq 'Fh';

            # self.fh.open(name) || die "cannot open file $@";
            $self->fh->open($name);
            $self->fh->binmod() if $self->binmod;

            if ($cmd eq 'read'){
                $res = __RISE_JOIN('', [$self->fh->getlines()]) || __PACKAGE__->__RISE_ERR('ISFILE', $self->path->filename($name));
            }

            $res = $self->fh->write($data)           if $cmd eq 'write';
            $res = $self->fh->write($data)           if $cmd eq 'append';
            $self->fh->close;
            return $res;
        }}

        { package rise::lib::fs::file::read; use rise::core::object::function;  sub read {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings;  ($self,$name) = ($_[0],$_[1]); 
            return $self->file('read', $name);
        }}

        { package rise::lib::fs::file::write; use rise::core::object::function;  sub write {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$name,$data) = ($_[0],$_[1],$_[2]); 
            return $self->file('write', $name, $data);
        }}

        { package rise::lib::fs::file::append; use rise::core::object::function;  sub append {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($self,$name,$data) = ($_[0],$_[1],$_[2]);
            return $self->file('append', $name, $data);
        }}

        { package rise::lib::fs::file::copy; use rise::core::object::function;  sub copy {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name1; no warnings; sub name1 ():lvalue; *name1 = sub ():lvalue { $name1 }; use warnings; my $name2; no warnings; sub name2 ():lvalue; *name2 = sub ():lvalue { $name2 }; use warnings;  ($self,$name1,$name2) = ($_[0],$_[1],$_[2]);
            return $self->fhelper->fcopy($name1, $name2);
        }}

        { package rise::lib::fs::file::move; use rise::core::object::function;  sub move {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name_old; no warnings; sub name_old ():lvalue; *name_old = sub ():lvalue { $name_old }; use warnings; my $name_new; no warnings; sub name_new ():lvalue; *name_new = sub ():lvalue { $name_new }; use warnings;  ($self,$name_old,$name_new) = ($_[0],$_[1],$_[2]);
            return $self->fhelper->fmove($name_old, $name_new);
        }}

        { package rise::lib::fs::file::delete; use rise::core::object::function;  sub delete {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);
            unlink $name;
        }}

    }

    { package rise::lib::fs::fileHelper; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1018013856"; sub VERSION {"2016.1018013856"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-fcopy  public-function-fmove}} 
        use File::Copy;

        { package rise::lib::fs::fileHelper::fcopy; use rise::core::object::function;  sub fcopy {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name1; no warnings; sub name1 ():lvalue; *name1 = sub ():lvalue { $name1 }; use warnings; my $name2; no warnings; sub name2 ():lvalue; *name2 = sub ():lvalue { $name2 }; use warnings;  ($self,$name1,$name2) = ($_[0],$_[1],$_[2]);
            return File::Copy::copy($name1, $name2);
        }}

        { package rise::lib::fs::fileHelper::fmove; use rise::core::object::function;  sub fmove {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name_old; no warnings; sub name_old ():lvalue; *name_old = sub ():lvalue { $name_old }; use warnings; my $name_new; no warnings; sub name_new ():lvalue; *name_new = sub ():lvalue { $name_new }; use warnings;  ($self,$name_old,$name_new) = ($_[0],$_[1],$_[2]);
            return File::Copy::move($name_old, $name_new);
        }}
    }
}

1;