use rise::lib::fs;
use rise::lib::tman::fmm;
use Audio::Beep;
use rise::lib::txt;

{ package rise::lib; use rise::core::object::namespace;   

    { package rise::lib::tman; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1114205141"; sub VERSION {"2016.1114205141"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{private-function-sndOK  private-function-sndERR  public-function-src  public-function-dst  private-function-referPath  export:simple-function-plugin  export:simple-function-tman  export:simple-function-task  public-function-watch  export:simple-function-start  private-thread-watch_go  private-var-fs  private-var-fmon  private-var-txt  private-var-snd  private-var-snd_OK  private-var-snd_ERR  private-var-tlast  private-var-tcurrent  private-var-tcode  private-var-tstack  private-var-wcode  private-var-wstack  private-var-wstart  private-var-code_src  private-var-code_res  private-var-filename  private-var-basename  private-var-src_path  private-var-src_name  private-var-dst_name  private-var-dst_ext  public-var-ref_path  public-var-dst_file}} sub __EXPORT__ { {":all"=>[qw/plugin tman task start/],":function"=>[qw/plugin tman task start/],":simple"=>[qw/plugin tman task start/],"plugin"=>[qw/plugin/],"start"=>[qw/start/],"task"=>[qw/task/],"tman"=>[qw/tman/],} } 

         sub fs ():lvalue; no warnings; *__fs__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fs') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'fs'} }; *fs = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fs') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'fs'} }; use warnings;  fs = new rise::lib::fs::;
		 sub fmon ():lvalue; no warnings; *__fmon__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fmon') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'fmon'} }; *fmon = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fmon') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'fmon'} }; use warnings;  fmon = new rise::lib::tman::fmm::;
         sub txt ():lvalue; no warnings; *__txt__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'txt') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'txt'} }; *txt = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'txt') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'txt'} }; use warnings;  txt = new rise::lib::txt::;
		 sub snd ():lvalue; no warnings; *__snd__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'snd') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'snd'} }; *snd = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'snd') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'snd'} }; use warnings;  snd = new Audio::Beep::;

		 sub snd_OK ():lvalue; no warnings; *__snd_OK__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'snd_OK') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'snd_OK'} }; *snd_OK = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'snd_OK') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'snd_OK'} }; use warnings;  snd_OK = "f'20 d25";
		 sub snd_ERR ():lvalue; no warnings; *__snd_ERR__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'snd_ERR') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'snd_ERR'} }; *snd_ERR = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'snd_ERR') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'snd_ERR'} }; use warnings;  snd_ERR = "g'20 g10.. g20 g10..";

		 sub tlast ():lvalue; no warnings; *__tlast__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tlast') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'tlast'} }; *tlast = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tlast') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'tlast'} }; use warnings; 
		 sub tcurrent ():lvalue; no warnings; *__tcurrent__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tcurrent') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'tcurrent'} }; *tcurrent = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tcurrent') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'tcurrent'} }; use warnings; 
		 sub tcode ():lvalue; no warnings; *__tcode__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tcode') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'tcode'} }; *tcode = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tcode') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'tcode'} }; use warnings;  tcode = {};
		 sub tstack ():lvalue; no warnings; *__tstack__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tstack') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'tstack'} }; *tstack = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tstack') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'tstack'} }; use warnings;  tstack = {};
		 sub wcode ():lvalue; no warnings; *__wcode__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wcode') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'wcode'} }; *wcode = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wcode') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'wcode'} }; use warnings;  wcode = {};
		 sub wstack ():lvalue; no warnings; *__wstack__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wstack') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'wstack'} }; *wstack = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wstack') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'wstack'} }; use warnings;  wstack = {};
		 sub wstart ():lvalue; no warnings; *__wstart__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wstart') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'wstart'} }; *wstart = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wstart') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'wstart'} }; use warnings;  wstart = 0;

		 sub code_src ():lvalue; no warnings; *__code_src__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'code_src') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'code_src'} }; *code_src = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'code_src') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'code_src'} }; use warnings; 
		 sub code_res ():lvalue; no warnings; *__code_res__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'code_res') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'code_res'} }; *code_res = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'code_res') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'code_res'} }; use warnings; 
		 sub filename ():lvalue; no warnings; *__filename__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'filename') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'filename'} }; *filename = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'filename') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'filename'} }; use warnings; 
		 sub basename ():lvalue; no warnings; *__basename__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'basename') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'basename'} }; *basename = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'basename') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'basename'} }; use warnings; 
		 sub src_path ():lvalue; no warnings; *__src_path__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'src_path') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'src_path'} }; *src_path = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'src_path') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'src_path'} }; use warnings; 
		 sub src_name ():lvalue; no warnings; *__src_name__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'src_name') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'src_name'} }; *src_name = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'src_name') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'src_name'} }; use warnings; 
		# var lsrc_name;
		# var dst_path;
		 sub dst_name ():lvalue; no warnings; *__dst_name__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dst_name') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'dst_name'} }; *dst_name = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dst_name') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'dst_name'} }; use warnings; 
		 sub dst_ext ():lvalue; no warnings; *__dst_ext__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dst_ext') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self = shift; $self->{'dst_ext'} }; *dst_ext = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dst_ext') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $__RISE_SELF__->{'dst_ext'} }; use warnings;  dst_ext = 'tman';
		 sub ref_path ():lvalue; no warnings; *__ref_path__ = sub ():lvalue {  my $self = shift; $self->{'ref_path'} }; *ref_path = sub ():lvalue {  $__RISE_SELF__->{'ref_path'} }; use warnings;  ref_path = 'NO PATH';
		 sub dst_file ():lvalue; no warnings; *__dst_file__ = sub ():lvalue {  my $self = shift; $self->{'dst_file'} }; *dst_file = sub ():lvalue {  $__RISE_SELF__->{'dst_file'} }; use warnings;  dst_file = 'NO DESTINATION';

		{ package rise::lib::tman::sndOK; use rise::core::object::function; sub sndOK { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'sndOK') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_;  
			# var sound					= new Audio.Beep;
			$self->snd->play($self->snd_OK);
		}}

		{ package rise::lib::tman::sndERR; use rise::core::object::function; sub sndERR { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'sndERR') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_;  
			# var sound					= new Audio.Beep;
			$self->snd->play($self->snd_ERR);
		}}

		# public function monitor (spath, diff = 2) {
		# 	var tdiff;
		# 	var sname;
		# 	var mname       = 0;
		#
		# 	foreach sname ( self.fs.dir.listf(spath) ) {
		# 		tdiff = time - self.fs.info.mtime(sname);
		# 		next if tdiff > diff;
		# 		mname = sname;
		# 		last if tdiff < diff;
		# 	}
		#
		# 	return mname;
		# }

		{ package rise::lib::tman::src; use rise::core::object::function;  sub src {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($path) = ($_[0]); 
			$self->src_path			= $path;
			# self.src_name			= undef;
			# self.src_name			= self.monitor(path,1);
			$self->src_name			= $self->fmon->monitor($path,1);

			# say ">>> name " ~ self.src_name if self.src_name;
			# say ">>> path " ~ self.src_path;

			if ($self->src_name) {
				# self.lsrc_name			= self.src_name if self.src_name;
				$self->filename			= $self->fs->path->filename($self->src_name);
				$self->basename			= $self->fs->path->basename($self->src_name);
                $self->dst_ext			= $self->fs->path->ext($self->src_name);
				$self->code_src			= $self->fs->file->read($self->src_name);

                # self.dst_file		    = self.basename ~ '.' ~ self.dst_ext;
			}

			return $self;
		}}

		{ package rise::lib::tman::dst; use rise::core::object::function;  sub dst {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($path) = ($_[0]); 
			if ($self->src_name) {
				# self.dst_path		= path;

				my $dpath; no warnings; sub dpath ():lvalue; *dpath = sub ():lvalue { $dpath }; use warnings;  $dpath = $path . $self->referPath();
				my $err; no warnings; sub err ():lvalue; *err = sub ():lvalue { $err }; use warnings;  $err = '';


				if(!$self->fs->info->isDir($dpath)){
                    # say '>>> dest dir ' ~ dpath;
					mkdir $dpath or $err = "ERROR: Cant make dir " . $dpath;
					if ($err) {
						say $err;
						$self->sndERR();
						return;
					}
					# say "mkdir $dpath";
				}

				$self->code_res		||= $self->code_src;
				$self->dst_file		= $self->basename . '.' . $self->dst_ext;
				$self->dst_name		= $dpath . $self->dst_file;
				$self->fs->file->write($self->dst_name, $self->code_res) if $self->code_res;
				$self->sndOK();
			}
			# self.snd.play(self.snd_OK);
			return $self;
		}}

		{ package rise::lib::tman::referPath; use rise::core::object::function; sub referPath { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'referPath') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_;  
			my $spath; no warnings; sub spath ():lvalue; *spath = sub ():lvalue { $spath }; use warnings;  $spath = $self->src_path;
			$spath               =~ s{^([^\*]*).*?$}{$1}sx;
			 my $ref_path; no warnings; sub ref_path ():lvalue; *ref_path = sub ():lvalue { $ref_path }; use warnings;  ($ref_path) = __RISE_MATCH $self->src_name =~ m{^$spath(.*?)$}sx;
			$self->ref_path		= $self->fs->path->path($ref_path);
			return $self->ref_path;
		}}

		{ package rise::lib::tman::plugin; use rise::core::object::function;  sub plugin {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings;  ($name) = ($_[0]); 
			no strict;
			require 'rise/lib/tman/plugin/' . $name . '.pm';
            # say '>>> plugin >>> ' ~ name;


            *{'rise::lib::tman::' . $name} = \&{'rise::lib::tman::plugin::' . $name . '::plugin'};

            # var p = ('rise::lib::tman::plugin::' ~ name)->new;
            # *{"rise::lib::tman::$name"} = sub { shift \@_; p.plugin(@_) };
		}}

		{ package rise::lib::tman::tman; use rise::core::object::function;  sub tman {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_;  
            # say "tman OK";
			return $self;
		}}

        { package rise::lib::tman::task; use rise::core::object::function;  sub task {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $taskName; no warnings; sub taskName ():lvalue; *taskName = sub ():lvalue { $taskName }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($taskName,$data) = ($_[0],$_[1]); 
			$self->tlast		= $taskName;
            $self->tstack->{$taskName} = [];
			if (ref $data eq 'CODE') {
				$self->tcode->{$taskName} = $data;
				$data = [$taskName];
			}
            __RISE_PUSH $self->tstack->{$taskName}, $data;
        }}

        { package rise::lib::tman::watch; use rise::core::object::function;  sub watch {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($path,$data) = ($_[0],$_[1]); 
			$self->wstart = 1;
			# say '###>> ' ~ dump data;
			# self.wcode.{self.tcurrent}	= [];
			$self->wstack->{$self->tcurrent}	= [] if ref $self->wstack->{$self->tcurrent} ne 'ARRAY';
			my $wc; no warnings; sub wc ():lvalue; *wc = sub ():lvalue { $wc }; use warnings;  $wc = [];

			{ my $tname; no warnings; sub tname ():lvalue; *tname = sub ():lvalue { $tname }; use warnings;  foreach (@ {($data)}) { $tname = $_;
                # say '### WATCH ' ~ tname;
				__RISE_PUSH $wc, $self->watch_go($tname, $path, $self->tcode->{$tname});
			}}

			if (ref $data eq 'CODE') {
				# say '>>> ' ~ self.tcurrent;
				__RISE_PUSH $wc, $self->watch_go($self->tcurrent, $path, $data);
				$data = [$self->tcurrent];
			}

			$self->wcode->{$self->tcurrent} = $wc;
			__RISE_PUSH $self->wstack->{$self->tcurrent}, $data;

			return $self;
        }}

        { package rise::lib::tman::start; use rise::core::object::function;  sub start {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $tname; no warnings; sub tname ():lvalue; *tname = sub ():lvalue { $tname }; use warnings;  ($tname) = ($_[0]); 
			$tname ||= 'default';
			say ' ';
			# say self.txt.line ({ title => 'tman START' });
			say $self->txt->box (' v' . $self->VERSION . "\n" .
                ' task lists: ' . dump (__RISE_KEYS $self->tstack) . "\n" .
                ' start tasks... ', 'TMAN Simple Task Manager Lib');

			{ my $task; no warnings; sub task ():lvalue; *task = sub ():lvalue { $task }; use warnings;  foreach (@ {($self->tstack->{$tname})}) { $task = $_;
				say $self->txt->line ({ title => 'TASK: ' . $task, char => '-' });
				$self->tcurrent		= $task;
				#self.init();
				$self->tcode->{$task}();
				if ($self->wstart) {
					{ my $wath; no warnings; sub wath ():lvalue; *wath = sub ():lvalue { $wath }; use warnings;  foreach (@ {($self->wstack->{$task})}) { $wath = $_;
                        # say '### WATCH ' ~ wath;
						{ my $wcode; no warnings; sub wcode ():lvalue; *wcode = sub ():lvalue { $wcode }; use warnings;  foreach (@ {($self->wcode->{$task})}) { $wcode = $_;
							# wcode.join if wcode;
							$wcode->join;
							# wcode.() if wcode;
						}}
					}}
				}
			}}
			$self->wstart = 0;
			say $self->txt->line ({ title => 'tman END' });
			say ' ';
        }}

		# function action_reg (aname, code) {
		# 	self.tcode.{aname} = code;
		# }

		{ package rise::lib::tman::watch_go; use rise::core::object::thread; sub watch_go  { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'watch_go') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $thr; $thr = threads->create(sub{my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = $_[0]; my $tname; no warnings; sub tname ():lvalue; *tname = sub ():lvalue { $tname }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings; my $code; no warnings; sub code ():lvalue; *code = sub ():lvalue { $code }; use warnings;  ($tname,$path,$code) = ($_[1],$_[2],$_[3]); 
		# function watch_go (path, code) {
			# say '### PATH: ' ~ path ~ ' | DATA: ' ~ dump data;
            # say '### WATCH ' ~ tname;
			while( true ){
				$self->src($path);
                # self.src_name			= self.fmon.monitor(path,1);
				if ($self->src_name){
					# say self.txt.line ({ title => 'WATCH', char => '~' });
					$code->();
				}
                sleep 1;
			}
		}, @_); { no strict; no warnings; @{rise::lib::tman::THREAD::watch_go}[$thr->tid] = $thr; } return $thr; }}

    }
}

1;