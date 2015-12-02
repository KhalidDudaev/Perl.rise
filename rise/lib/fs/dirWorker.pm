# ^(.*?)[\\\/](?:(\*|\?+)[\\\/])?([^\\\/]+)$

{ package rise::lib::fs; use rise::core::object::namespace;   

    { package rise::lib::fs::dirWorker; use rise::core::object::class;  

        my $slash; no warnings; sub slash ():lvalue; *slash = sub ():lvalue {  $slash }; use warnings; 

        { package rise::lib::fs::dirWorker::listhelper; use rise::core::object::function; sub listhelper { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'listhelper') unless (caller eq 'rise::lib::fs::dirWorker' || caller =~ m/^rise::lib::fs::dirWorker\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
            my $dlist; no warnings; sub dlist ():lvalue; *dlist = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dlist') unless (caller eq 'rise::lib::fs::dirWorker::listhelper' || caller =~ m/^rise::lib::fs::dirWorker::listhelper\b/o); $dlist }; use warnings;  $dlist = [];
             my $slash; no warnings; sub slash ():lvalue; *slash = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'slash') unless (caller eq 'rise::lib::fs::dirWorker::listhelper' || caller =~ m/^rise::lib::fs::dirWorker::listhelper\b/o); $slash }; use warnings;  ($slash) = __RISE_MATCH $path =~ m{(\\|\/)}sx;

            $slash           = $self->slash || $slash;

            opendir(DIR, $path);
            { my $item; no warnings; local *item; sub item ():lvalue; *item = sub ():lvalue {  $item }; use warnings;  foreach (readdir DIR) { $item = $_;
                __RISE_PUSH $dlist, $path . $item if __RISE_MATCH $item !~ m{^(?:\.|\.\.)$};
            }}
            closedir DIR;

            return $dlist;
        }}

        { package rise::lib::fs::dirWorker::list; use rise::core::object::function; sub  list {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings; my $filtrItem; no warnings; local *filtrItem; sub filtrItem ():lvalue; *filtrItem = sub ():lvalue {  $filtrItem }; use warnings;  ($self,$path,$filtrItem) = ($_[0],$_[1],$_[2]||'');
            my $res; no warnings; sub res ():lvalue; *res = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'res') unless (caller eq 'rise::lib::fs::dirWorker::list' || caller =~ m/^rise::lib::fs::dirWorker::list\b/o); $res }; use warnings;  $res = [];
            my $dir; no warnings; sub dir ():lvalue; *dir = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dir') unless (caller eq 'rise::lib::fs::dirWorker::list' || caller =~ m/^rise::lib::fs::dirWorker::list\b/o); $dir }; use warnings; 
            my $fltrD; no warnings; sub fltrD ():lvalue; *fltrD = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fltrD') unless (caller eq 'rise::lib::fs::dirWorker::list' || caller =~ m/^rise::lib::fs::dirWorker::list\b/o); $fltrD }; use warnings; 
            my $fltrF; no warnings; sub fltrF ():lvalue; *fltrF = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fltrF') unless (caller eq 'rise::lib::fs::dirWorker::list' || caller =~ m/^rise::lib::fs::dirWorker::list\b/o); $fltrF }; use warnings; 
            my $isD; no warnings; sub isD ():lvalue; *isD = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'isD') unless (caller eq 'rise::lib::fs::dirWorker::list' || caller =~ m/^rise::lib::fs::dirWorker::list\b/o); $isD }; use warnings;  $isD = 1;
            my $isF; no warnings; sub isF ():lvalue; *isF = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'isF') unless (caller eq 'rise::lib::fs::dirWorker::list' || caller =~ m/^rise::lib::fs::dirWorker::list\b/o); $isF }; use warnings;  $isF = 1;
             my $slash; no warnings; sub slash ():lvalue; *slash = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'slash') unless (caller eq 'rise::lib::fs::dirWorker::list' || caller =~ m/^rise::lib::fs::dirWorker::list\b/o); $slash }; use warnings;  ($slash) = __RISE_MATCH $path =~ m{(\\|\/)}sx;

            $isD             = 0 if $filtrItem eq 'file';
            $isF             = 0 if $filtrItem eq 'dir';

            $slash           = $self->slash || $slash;
            $path            = [$path] if ref $path ne 'ARRAY';

            { my $dname; no warnings; local *dname; sub dname ():lvalue; *dname = sub ():lvalue {  $dname }; use warnings;  foreach (@ {($path)}) { $dname = $_;
                ($dir, $fltrD, $fltrF) = $self->filterExtract($dname);
                $dir         ||= $dname;
                $fltrD       ||= '';
                $fltrF       ||= '*.*';

                # say 'path     -> ' ~ dname;
                # say 'dir      -> ' ~ dir;
                # say 'filter D -> ' ~ fltrD;
                # say 'filter F -> ' ~ fltrF;

                { my $item; no warnings; local *item; sub item ():lvalue; *item = sub ():lvalue {  $item }; use warnings;  foreach (@ {($self->listhelper($dir))}) { $item = $_;
                    __RISE_PUSH $path, $item . $slash . $fltrD . $slash . $fltrF if $self->isDir($item) && $self->filter($item, $fltrD);
                    __RISE_PUSH $res, $item if $self->isDir($item) && $isD && $self->filter($item, $fltrF);
                    __RISE_PUSH $res, $item if $self->isFile($item) && $isF && $self->filter($item, $fltrF);
                }}
            }}
            return $res;
        }}

        { package rise::lib::fs::dirWorker::listf; use rise::core::object::function; sub  listf {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
            return $self->list($path, 'file');
        }}

        { package rise::lib::fs::dirWorker::listd; use rise::core::object::function; sub  listd {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
            return $self->list($path, 'dir');
        }}

        { package rise::lib::fs::dirWorker::filter; use rise::core::object::function; sub filter { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'filter') unless (caller eq 'rise::lib::fs::dirWorker' || caller =~ m/^rise::lib::fs::dirWorker\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings; my $fltr; no warnings; local *fltr; sub fltr ():lvalue; *fltr = sub ():lvalue {  $fltr }; use warnings;  ($self,$name,$fltr) = ($_[0],$_[1],$_[2]);
            $fltr        =~ s{([^\w\*\?])}{\\$1}gsx;
            $fltr        =~ s{\*\\\.\*}{*(?:\\.*)?}gsx;
            $fltr        =~ s{(?<![()])\?}{\\w}gsx;
            $fltr        =~ s{(?<!\\)\*}{\.\*\?}gsx;
            $name        =~ s{^(.*?)(\w+(?:\.\w+)*)$}{$2}sx;
            return __RISE_MATCH $name =~ m{^(?:$fltr)$}gsx;
        }}

        { package rise::lib::fs::dirWorker::filterExtract; use rise::core::object::function; sub filterExtract { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'filterExtract') unless (caller eq 'rise::lib::fs::dirWorker' || caller =~ m/^rise::lib::fs::dirWorker\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
             my $fltrD; no warnings; sub fltrD ():lvalue; *fltrD = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fltrD') unless (caller eq 'rise::lib::fs::dirWorker::filterExtract' || caller =~ m/^rise::lib::fs::dirWorker::filterExtract\b/o); $fltrD }; use warnings; 
             my $fltrF; no warnings; sub fltrF ():lvalue; *fltrF = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fltrF') unless (caller eq 'rise::lib::fs::dirWorker::filterExtract' || caller =~ m/^rise::lib::fs::dirWorker::filterExtract\b/o); $fltrF }; use warnings; 
             ($path, $fltrD, $fltrF) = m{^(.*?[\\\/])(?:(\*|\?+)[\\\/])?([^\\\/]+)?$}sx;
             return ($path, $fltrD, $fltrF);
        }}

        { package rise::lib::fs::dirWorker::isFile; use rise::core::object::function; sub  isFile {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);  -e $name && !-d _ }}
        { package rise::lib::fs::dirWorker::isDir; use rise::core::object::function; sub  isDir {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);   -d $name }}

    }
}

1;