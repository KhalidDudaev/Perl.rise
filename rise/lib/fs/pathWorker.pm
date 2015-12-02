{ package rise::lib::fs; use rise::core::object::namespace;   
    { package rise::lib::fs::pathWorker; use rise::core::object::class;  

        # public var slash          = '/';

        { package rise::lib::fs::pathWorker::cwd; use rise::core::object::function; sub  cwd {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]); 
             my $cwdir; no warnings; sub cwdir ():lvalue; *cwdir = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'cwdir') unless (caller eq 'rise::lib::fs::pathWorker::cwd' || caller =~ m/^rise::lib::fs::pathWorker::cwd\b/o); $cwdir }; use warnings;  ($cwdir) = toList __RISE_MATCH $0 =~ m{^(.*?)[^\\\/]*$}sx;
            return $cwdir;
        }}

        { package rise::lib::fs::pathWorker::toAbs; use rise::core::object::function; sub  toAbs {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            $fname = $self->cwd . $fname if $self->isRel($fname);
            return $fname;
        }}

        { package rise::lib::fs::pathWorker::toRel; use rise::core::object::function; sub  toRel {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            my $cwdir; no warnings; sub cwdir ():lvalue; *cwdir = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'cwdir') unless (caller eq 'rise::lib::fs::pathWorker::toRel' || caller =~ m/^rise::lib::fs::pathWorker::toRel\b/o); $cwdir }; use warnings;  $cwdir = $self->cwd;
            $cwdir =~ s{\\}{\\\\}gsx;
            $fname =~ s{$cwdir}{}sx;
            # fname =~ replace:sx cwdir => "";
            return $fname;
        }}

        { package rise::lib::fs::pathWorker::isAbs; use rise::core::object::function; sub  isAbs {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            return __RISE_MATCH $fname =~ m{^(?:\w+\:|[\W]+)};
        }}

        { package rise::lib::fs::pathWorker::isRel; use rise::core::object::function; sub  isRel {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            return __RISE_MATCH $fname !~ m{^(?:\w+\:|[\W]+)};
        }}

        { package rise::lib::fs::pathWorker::path; use rise::core::object::function; sub  path {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
             my $p; no warnings; sub p ():lvalue; *p = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'p') unless (caller eq 'rise::lib::fs::pathWorker::path' || caller =~ m/^rise::lib::fs::pathWorker::path\b/o); $p }; use warnings;  ($p) = __RISE_MATCH $fname =~ m{^(.*?)[^\\\/]*$}sx;
             return $p;
        }}

        { package rise::lib::fs::pathWorker::filename; use rise::core::object::function; sub  filename {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            $fname      =~ s{^.*?([^\\\/]*)$}{$1}sx;
            return $fname;
        }}

        { package rise::lib::fs::pathWorker::basename; use rise::core::object::function; sub  basename {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            $fname      =~ s{^.*?(\w+(?:\.\w+)*)$}{$1}sx;
            $fname      =~ s{^(.*?)(?:\.(\w+))?$}{$1}sx;
            return $fname;
        }}

        { package rise::lib::fs::pathWorker::ext; use rise::core::object::function; sub  ext {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            $fname      =~ s{^.*?(\w+(?:\.\w+)*)$}{$1}sx;
            $fname      =~ s{^(.*?)(?:\.(\w+))?$}{$2}sx;
            return $fname;
        }}
    }
}

1;