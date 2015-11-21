{ package rise::lib::fs;  use strict; use warnings;   

    { package rise::lib::fs::dirWorker; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::class','rise::lib::fs';   sub super { $rise::lib::fs::dirWorker::ISA[1] } my $self = 'rise::lib::fs::dirWorker'; sub self { $self }; BEGIN { __PACKAGE__->__RISE_COMMANDS } __PACKAGE__->interface_confirm; sub __OBJLIST__ {'public-function-list public-function-listf public-function-listd private-function-filter public-function-isFile public-function-isDir'}

        { package rise::lib::fs::dirWorker::list; use rise::core::object::funcdecl; sub  list {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings;  ($self,$path) = ($_[0],$_[1]); 
            my $dlist; no warnings; sub dlist ():lvalue; *dlist = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dlist') unless (caller eq 'rise::lib::fs::dirWorker::list' || caller =~ m/^rise::lib::fs::dirWorker::list\b/o); $dlist }; use warnings;  $dlist = [];

            opendir(DIR, $path);
            { my $item; no warnings; local *item; sub item ():lvalue; *item = sub ():lvalue {  $item }; use warnings;  foreach (readdir DIR) { $item = $_;
                __RISE_PUSH $dlist, $path . '/' . $item if __RISE_MATCH $item !~m/^(?:\.|\.\.)$/;
            }}
            closedir DIR;

            return $dlist;
        }}

        { package rise::lib::fs::dirWorker::listf; use rise::core::object::funcdecl; sub  listf {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $dir; no warnings; local *dir; sub dir ():lvalue; *dir = sub ():lvalue {  $dir }; use warnings; my $params; no warnings; local *params; sub params ():lvalue; *params = sub ():lvalue {  $params }; use warnings;  ($self,$dir,$params) = ($_[0],$_[1],$_[2]); 
            my $dir_arr; no warnings; sub dir_arr ():lvalue; *dir_arr = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dir_arr') unless (caller eq 'rise::lib::fs::dirWorker::listf' || caller =~ m/^rise::lib::fs::dirWorker::listf\b/o); $dir_arr }; use warnings;  $dir_arr = [$dir];
            my $res; no warnings; sub res ():lvalue; *res = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'res') unless (caller eq 'rise::lib::fs::dirWorker::listf' || caller =~ m/^rise::lib::fs::dirWorker::listf\b/o); $res }; use warnings;  $res = [];

            $params->{deep}   ||= 0;
            $params->{filter} ||= '*.*';

            { my $dname; no warnings; local *dname; sub dname ():lvalue; *dname = sub ():lvalue {  $dname }; use warnings;  foreach (@ {($dir_arr)}) { $dname = $_;
                { my $item; no warnings; local *item; sub item ():lvalue; *item = sub ():lvalue {  $item }; use warnings;  foreach (@ {($self->list($dname))}) { $item = $_;
                    __RISE_PUSH $dir_arr, $item if $self->isDir($item) && $params->{deep};
                    __RISE_PUSH $res, $item if $self->isFile($item) && $self->filter($item, $params->{filter});
                }}
            }}
            return $res;
        }}

        { package rise::lib::fs::dirWorker::listd; use rise::core::object::funcdecl; sub  listd {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $dir; no warnings; local *dir; sub dir ():lvalue; *dir = sub ():lvalue {  $dir }; use warnings; my $params; no warnings; local *params; sub params ():lvalue; *params = sub ():lvalue {  $params }; use warnings;  ($self,$dir,$params) = ($_[0],$_[1],$_[2]); 
            my $dir_arr; no warnings; sub dir_arr ():lvalue; *dir_arr = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dir_arr') unless (caller eq 'rise::lib::fs::dirWorker::listd' || caller =~ m/^rise::lib::fs::dirWorker::listd\b/o); $dir_arr }; use warnings;  $dir_arr = [$dir];
            my $res; no warnings; sub res ():lvalue; *res = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'res') unless (caller eq 'rise::lib::fs::dirWorker::listd' || caller =~ m/^rise::lib::fs::dirWorker::listd\b/o); $res }; use warnings;  $res = [];

            $params->{deep}   ||= 0;
            $params->{filter} ||= '*';

            { my $dname; no warnings; local *dname; sub dname ():lvalue; *dname = sub ():lvalue {  $dname }; use warnings;  foreach (@ {($dir_arr)}) { $dname = $_;
                { my $item; no warnings; local *item; sub item ():lvalue; *item = sub ():lvalue {  $item }; use warnings;  foreach (@ {($self->list($dname))}) { $item = $_;
                    if($self->isDir($item)){
                        __RISE_PUSH $dir_arr, $item if $params->{deep};
                        __RISE_PUSH $res, $item if $self->filter($item, $params->{filter});
                    }
                }}
            }}
            return $res;
        }}

        { package rise::lib::fs::dirWorker::filter; use rise::core::object::funcdecl; sub filter { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'filter') unless(caller eq 'rise::lib::fs::dirWorker' || caller =~ m/^rise::lib::fs::dirWorker\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings; my $fltr; no warnings; local *fltr; sub fltr ():lvalue; *fltr = sub ():lvalue {  $fltr }; use warnings;  ($self,$name,$fltr) = ($_[0],$_[1],$_[2]); 
            $fltr        =~ s/([^\w\*\?])/\\$1/gsx;
            $fltr        =~ s/\?/\\w/gsx;
            $fltr        =~ s/\*/\.\*\?/gsx;
            $name        =~ s/^(.*?)(\w+(?:\.\w+)*)$/$2/sx;
            return __RISE_MATCH $name =~m/^(?:$fltr)$/gsx;
        }}

        { package rise::lib::fs::dirWorker::isFile; use rise::core::object::funcdecl; sub  isFile  {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);  -e $name && !-d _ }}
        { package rise::lib::fs::dirWorker::isDir; use rise::core::object::funcdecl; sub  isDir   {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);  -d $name }}

    }
}

1;