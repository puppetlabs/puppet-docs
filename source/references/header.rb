

files = Dir.glob("**/*.markdown")

header = "---\nlayout: default\ntitle: "

files.each { |f|
  File.open(f).read() =~ /^\% (.*)\n/
  title = $1
  file = IO.read(f)
  open(f, 'w') { |f1| f1 << header << title << "\n---" << "\n\n" << file}
}

