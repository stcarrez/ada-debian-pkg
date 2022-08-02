#!/bin/bash
if test $# -ne 2; then
   echo "Usage:    dpkg-html.sh <dir> <name>"
   echo "Example:  dpkg-html.sh . ubuntu-bionic"
   exit 2
fi

DIR=$1
if test ! -d "$DIR"; then
   echo "Usage: dpkg-html.sh <dir> <name>"
   echo "$DIR is not a directory"
   exit 2
fi
TARGET=`pwd`
BASE=$2

cat <<EOF > /tmp/dpkg-awk.$$
BEGIN { start = 0; }
/Package:/ {
           if (start != 1) {
	      printf("<h2>Package %s</h2>\n<dl class='apt-info'>", \$2);
	      start = 1;
	   }
	   next;
        }
/:/	{ if (start == 1) {
		 printf("<dt>%s</dt><dd>\n", \$1);
		 for (i = 2; i <= NF; i++) {
			item = \$i
			gsub(/&/, "\\\&amp;", item)
			gsub(/</, "\\\&lt;", item)
			gsub(/>/, "\\\&gt;", item)
			printf(" %s", item);
		 }
		 if (\$1 != "Description:") {
		   printf("</dd>\n");
		 } else {
		   start = 2
		 }
	  }
	  next
	}
	{
	  if (start == 2) {
		 printf("%s\n", \$0);
	  }
	}
END {
	printf("</dd></dl>\n");
}
EOF

mkdir -p $TARGET/$BASE

# Generate the header for debian package files
function header() {

  cat <<EOF > $1
<ui:composition template="/WEB-INF/layouts/anonymous.xhtml"
        xmlns:ui="http://java.sun.com/jsf/facelets"
        xmlns:f="http://java.sun.com/jsf/core"
        xmlns:c="http://java.sun.com/jstl/core"
        xmlns:util="http://code.google.com/p/ada-asf/util"
        xmlns:h="http://java.sun.com/jsf/html">
    <ui:param name="title" value="Debian Package"/>
    <ui:param name="pageStyle" value="page-download page-$BASE"/>
    <ui:define name="pageBody">
      <div id='awa-content'>
          <div class='grid_9'>
<ui:include src="../../views/awa-project.xhtml"/>
<div class='apt-info'>
EOF
}

# Generate the footer
function footer() {
  cat <<EOF >> $1
</div>
          </div>
          <div class='grid_3 blog-post-info'>
              <ui:include src="../../blogs/lists/post-info.xhtml"/>
              <ui:include src="../../views/vacs-projects.xhtml"/>
              <ui:include src="../../views/ada-promote.xhtml"/>
          </div>
      </div>
    </ui:define>
</ui:composition>
EOF
}

function debian_info() {
  echo "Pattern=$1"
  local FILES=`cd $DIR; find . -name "$1" | sort | sed -e 's,^./,,'`
  if test "T$FILES" != "T"; then
    echo "<h2>$2</h2><ul class='apt-list'>" >> $TARGET/$BASE/index.xhtml
  fi
  for i in $FILES; do
    id=`basename $i`
    link=`basename $i .deb`.html
    name=`basename $i .deb`.xhtml

    header $TARGET/$BASE/$name
    echo "<div class='apt-info'>" >> $TARGET/$BASE/$name
    dpkg-deb --info $DIR/$i | gawk -f /tmp/dpkg-awk.$$ >> $TARGET/$BASE/$name

    echo "<div class='apt-download'><a href='https://apt.vacs.fr/$BASE/$i' class='apt-download'>Download</a></div>" >> $TARGET/$BASE/$name
    echo "<h2>Content</h2><div class='apt-list'><pre>" >> $TARGET/$BASE/$name
    dpkg-deb -c $DIR/$i >> $TARGET/$BASE/$name

    echo "</pre></div></div>" >> $TARGET/$BASE/$name
    footer $TARGET/$BASE/$name

    echo "<li>" >> $TARGET/$BASE/index.xhtml
    echo "<a href='$link'>" >> $TARGET/$BASE/index.xhtml
    echo $id >> $TARGET/$BASE/index.xhtml
    echo "</a><span>" >> $TARGET/$BASE/index.xhtml
    dpkg-deb --info $DIR/$i | grep Description | sed -e 's,Description:,,' >> $TARGET/$BASE/index.xhtml
    echo "</span></li>" >> $TARGET/$BASE/index.xhtml

  done
  if test "T$FILES" != "T"; then
    echo "</ul>" >> $TARGET/$BASE/index.xhtml
  fi
}

header $TARGET/$BASE/index.xhtml

debian_info "aflex*.deb" "Ada Lexical Analyzer generator"

debian_info "akt*.deb" "Ada Keystore Tool"

debian_info "are*.deb" "Advanced Resource Embedder"

debian_info "ayacc*.deb" "Ada LALR parser generator"

debian_info "libutilada*.deb" "Ada Utility Library"

debian_info "libelada*.deb" "Ada Expression Language Library"

debian_info "libkeystore*.deb" "Ada Keystore Library"

debian_info "libsecurity*.deb" "Ada Security Library"

debian_info "libservlet*.deb" "Ada Servlet Library"

debian_info "libasf*.deb" "Ada Server Faces Library"

debian_info "libwiki*.deb" "Ada Wiki Library"

debian_info "libado*.deb" "Ada Database Objects"

debian_info "libswagger*.deb" "OpenAPI Ada Library"

debian_info "libawa*.deb" "Ada Web Application"

debian_info "liblzma*.deb" "Ada LZMA Binding"

debian_info "dynamo*.deb" "Dynamo"

footer $TARGET/$BASE/index.xhtml

rm -f /tmp/dpkg-awk.$$
