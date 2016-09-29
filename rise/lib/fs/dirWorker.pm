
{ package rise::lib::fs; use rise::core::object::namespace;   

    { package rise::lib::fs::dirWorker; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.0929003752"; sub VERSION {"2016.0929003752"}; my $__CLASS_SELF__ = bless {};  

         sub slash ():lvalue; no warnings; *slash = sub ():lvalue { no strict;  my $self = shift || $__CLASS_SELF__; $self->{'slash'} ||= $__CLASS_SELF__->{'slash'}; $self->{'slash'} }; use warnings; 

        { package rise::lib::fs::dirWorker::listhelper; use rise::core::object::function;sub listhelper { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'listhelper') unless (caller eq 'rise::lib::fs::dirWorker' || caller =~ m/^rise::lib::fs::dirWorker\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
            my $dlist; no warnings; sub dlist ():lvalue; *dlist = sub ():lvalue { $dlist }; use warnings;  $dlist = [];
             my $slash; no warnings; sub slash ():lvalue; *slash = sub ():lvalue { $slash }; use warnings;  ($slash) = __RISE_MATCH $path =~ m{(\\|\/)}sx;

            $slash           = $self->slash || $slash;

            opendir(DIR, $path);
            { my $item; no warnings; sub item ():lvalue; *item = sub ():lvalue { $item }; use warnings;  foreach (readdir DIR) { $item = $_;
                __RISE_PUSH $dlist, $path . $item if __RISE_MATCH $item !~ m{^(?:\.|\.\.)$};
            }}
            closedir DIR;

            return $dlist;
        }}

        { package rise::lib::fs::dirWorker::list; use rise::core::object::function; sub list {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings; my $filtrItem; no warnings; sub filtrItem ():lvalue; *filtrItem = sub ():lvalue { $filtrItem }; use warnings;  ($self,$path,$filtrItem) = ($_[0],$_[1],$_[2]||'');
            my $res; no warnings; sub res ():lvalue; *res = sub ():lvalue { $res }; use warnings;  $res = [];
            my $dir; no warnings; sub dir ():lvalue; *dir = sub ():lvalue { $dir }; use warnings; 
            my $deep; no warnings; sub deep ():lvalue; *deep = sub ():lvalue { $deep }; use warnings;  $deep = 0;
            my $fltrN; no warnings; sub fltrN ():lvalue; *fltrN = sub ():lvalue { $fltrN }; use warnings;  $fltrN = 0;
            my $fltrD; no warnings; sub fltrD ():lvalue; *fltrD = sub ():lvalue { $fltrD }; use warnings; 
            my $fltrDC; no warnings; sub fltrDC ():lvalue; *fltrDC = sub ():lvalue { $fltrDC }; use warnings; 
            my $fltrF; no warnings; sub fltrF ():lvalue; *fltrF = sub ():lvalue { $fltrF }; use warnings; 
            my $filter; no warnings; sub filter ():lvalue; *filter = sub ():lvalue { $filter }; use warnings; 
            my $isD; no warnings; sub isD ():lvalue; *isD = sub ():lvalue { $isD }; use warnings;  $isD = 1;
            my $isF; no warnings; sub isF ():lvalue; *isF = sub ():lvalue { $isF }; use warnings;  $isF = 1;
             my $slash; no warnings; sub slash ():lvalue; *slash = sub ():lvalue { $slash }; use warnings;  ($slash) = __RISE_MATCH $path =~ m{(\\|\/)}sx;

            $slash           = $self->slash || $slash;
            $isD             = 0 if $filtrItem eq 'file';
            $isF             = 0 if $filtrItem eq 'dir';
            $path            .= $slash if __RISE_MATCH $path =~ m{^.*?[^\\\/]$}sx && $isD;
            $path            = [$path] if ref $path ne 'ARRAY';

            { my $dname; no warnings; sub dname ():lvalue; *dname = sub ():lvalue { $dname }; use warnings;  foreach (@ {($path)}) { $dname = $_;
                $fltrDC = '';
                ($dir, $fltrD, $fltrF) = $self->filterExtract($dname);

                if ($fltrD && $fltrD =~ s{^([^\\\/]*)[\\\/]}{}sx){
                    $fltrDC = $1;
                }

                $fltrD = $fltrDC . $slash if $fltrDC eq '**';

                # dir         ||= dname;
                # fltrD       ||= '';
                # fltrF       ||= '*.*';

                # say 'dir      -> ' ~ dname;
                # say 'path     -> ' ~ dname;
                # say 'filter D -> ' ~ fltrDC ~ ' | ' ~ fltrD;
                # say 'filter F -> ' ~ fltrF;

                { my $item; no warnings; sub item ():lvalue; *item = sub ():lvalue { $item }; use warnings;  foreach (@ {($self->listhelper($dir))}) { $item = $_;
                    __RISE_PUSH $path, $item . $slash . $fltrD . $fltrF if $self->isDir($item) && $self->filter($item, $fltrDC);
                    __RISE_PUSH $res, $item if $self->isDir($item) && $isD && $self->filter($item, $fltrDC);
                    __RISE_PUSH $res, $item if $self->isFile($item) && $isF && $self->filter($item, $fltrF) && ($fltrDC eq '**' || !$fltrDC);
                    # say 'item -> ' ~ item;
                    # say 'path -> ' ~ dump path;
                }}
            }}

            return $res;
        }}

        { package rise::lib::fs::dirWorker::listf; use rise::core::object::function; sub listf {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
            return $self->list($path, 'file');
        }}

        { package rise::lib::fs::dirWorker::listd; use rise::core::object::function; sub listd {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
            return $self->list($path, 'dir');
        }}

        { package rise::lib::fs::dirWorker::filter; use rise::core::object::function;sub filter { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'filter') unless (caller eq 'rise::lib::fs::dirWorker' || caller =~ m/^rise::lib::fs::dirWorker\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings; my $fltr; no warnings; sub fltr ():lvalue; *fltr = sub ():lvalue { $fltr }; use warnings;  ($self,$name,$fltr) = ($_[0],$_[1],$_[2]);
            $fltr        =~ s{([^\w\*\?])}{\\$1}gsx;
            $fltr        =~ s{\*\\\.\*}{*(?:\\.*)?}gsx;
            $fltr        =~ s{(?<![()])\?}{\\w}gsx;
            $fltr        =~ s{(?<!\\)\*}{\.\*\?}gsx;
            $name        =~ s{^(.*?)(\w+(?:\.\w+)*)$}{$2}sx;
            return __RISE_MATCH $name =~ m{^(?:$fltr)$}gsx;
        }}

        { package rise::lib::fs::dirWorker::filterExtract; use rise::core::object::function;sub filterExtract { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'filterExtract') unless (caller eq 'rise::lib::fs::dirWorker' || caller =~ m/^rise::lib::fs::dirWorker\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($self,$path) = ($_[0],$_[1]);
             my $fltrD; no warnings; sub fltrD ():lvalue; *fltrD = sub ():lvalue { $fltrD }; use warnings; 
             my $fltrF; no warnings; sub fltrF ():lvalue; *fltrF = sub ():lvalue { $fltrF }; use warnings; 
             ($path, $fltrD, $fltrF) = m{^([^\*\?]+[\\\/])([\w\?\*\.\\\/]+[\\\/])*([^\\\/]*)?$}sx;
            #  (path, fltrD, fltrF) = m{^([^\*\?]+[\\\/])(?:([\w\?\*\.]*)[\\\/])?([^\\\/]*)$}sx;
            #  (path, fltrD, fltrF) = m{^(.*?[\\\/])(?:(\*\*|\?+)[\\\/])?([^\\\/]+)?$}sx;
             return ($path, $fltrD, $fltrF);

            #  var filter;
            #  (path, filter) = m{^([^\*\?]+[\\\/])(.*?)$}sx;
            #  return (path, filter);
        }}

        # public function filterExpand(path) {
        #     var npath   = [];
        #     var npath2   = [];
        #     var cp;
        #     var fltr;
        #     var dir;
        #
        #     path            = [path] if ref path ne 'ARRAY';
        #
        #     foreach dir (path) {
        #         // (cp, fltr) = dir =~ m{^([^\*\?]+[\\\/])(?:([\w\?\*\.]*)[\\\/])?([^\\\/]*)$}sx;
        #         (cp, fltr) = dir =~ m{^(.*?[\\\/])(\*(?!\*).*?)$}sx;
        #         push npath2, cp;
        #         npath = self.listd(cp) if fltr;
        #         npath2 = clone npath;
        #         map { $_ ~= fltr } npath;
        #         push npath2, filterExpand(npath) if fltr;
        #     }
        #
        #     return npath2;
        # }

        { package rise::lib::fs::dirWorker::isFile; use rise::core::object::function; sub isFile {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);  -e $name && !-d _ }}
        { package rise::lib::fs::dirWorker::isDir; use rise::core::object::function; sub isDir {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);   -d $name }}

    }
}

1;