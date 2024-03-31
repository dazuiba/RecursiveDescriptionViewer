// frida -n "XXXX" -l hack.js
// var a=ObjC.classes.NSApplication.sharedApplication().windows().objectAtIndex_(1)
// pwindow(a)
function pwindow(window){
    const contentView = window.contentView();
    console.log(pview2(contentView,""))
}


function pview2(view, indent) {
    var frame = view.frame()
    frame[0].join(" ")
    
    var description = `${indent}<${view.class().toString()}: ${view.handle}; frame = (${frame[0].join(" ")}; ${frame[1].join(" ")})>\n`;
    //console.log(description)
    for (let i = 0; i < view.subviews().count(); i++) {
        const subview = view.subviews().objectAtIndex_(i);
        description += pview2(subview, indent + "   | ");
    }
    return description;
}
