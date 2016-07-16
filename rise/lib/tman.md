# stm
## - the Simply Task Manager
# TMan
## - Task Manager like ***gulp*** task menager

### methods:

- task
- start
- plugin

### default methods of object **tman**:

- **tman->src(**"[path/]filename.ext"**)** or **tman->src(**"[path/]***mask***"**)**
- **tman->dst(**"path/"**)**
- **tman->watch(**"[path/]filename.ext"**)** or **tman->watch(**"[path/]***mask***"**)**
- **tman->ref_path**
- **tman->dst_file**


if will modification file *`path/myfile.txt`* and write modifier data to new file destination in *`path2/`*

examle:

    use rise::lib::tman ':simple';

    task 'mytask' => sub {
        tman->src('path/myfile.txt')
            ->dst('path2/');
    };

    task 'default', ['mytask'];

    start;
In ***tman*** includes default task named ***default***.
Command **`start`** starts the default task
###
syntax **`task`** function:

    task 'taskname1' => sub {...};
    task 'taskname2' => sub {...};
    #or..
    task 'taskname3' => ['taskname1', 'taskname2', ...];

1

    plugin 'ftp';
    plugin 'notify';

    task 'compile' => sub {
        tman->src('C:/_DATA_EXT/_data/works/Development/_PERL/_apps/app/**/*.class')
    		->puma({ debug => 1, info  => 0 })
        	->dst('C:/_DATA_EXT/_data/works/Development/_PERL/_apps/appdist/')
    		->notify('puma compile ...' . tman->ref_path . tman->dst_file);
    };

    task 'ftp' => sub {
    	tman->src('C:/_DATA_EXT/_data/works/Development/_PERL/_apps/appdist/**/*.pm')
    		->ftp({
    			host	=> 'ftp.infocentersupport.com',
    			user	=> 'chechen@infocentersupport.com',
    			pass	=> 'sanhome',
    			path	=> '/distr'
    		})
    		->notify('ftp transfer ...' . tman->ref_path . tman->dst_file);
    };

    task 'watch' => sub {
    	tman->watch('C:/_DATA_EXT/_data/works/Development/_PERL/_apps/app/**/*.class', ['compile']);
    	tman->watch('C:/_DATA_EXT/_data/works/Development/_PERL/_apps/appdist/**/*.pm', ['ftp']);
    };

    task 'default', ['watch'];

    start;
