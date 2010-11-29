function size(bytes){   // simple function to show a friendly size
    var i = 0;
    while(1023 < bytes){
        bytes /= 1024;
        ++i;
    };
    return  i ? bytes.toFixed(2) + ["", " Kb", " Mb", " Gb", " Tb"][i] : bytes + " bytes";
};
function init_upload_file_controls(container){ 
        // create element
          
          container.appendChild(document.createElement("br"));
          container.appendChild(document.createElement("hr"));
          var input = container.appendChild(document.createElement("input")),
              sub = container.appendChild(document.createElement("div")).appendChild(document.createElement("span")),
              bar = container.appendChild(document.createElement("div")).appendChild(document.createElement("span")),
              div = container.appendChild(document.createElement("div"));
          
          // set input type as file
          input.setAttribute("type", "file");
          
          // enable multiple selection (note: it does not work with direct input.multiple = true assignment)
          input.setAttribute("multiple", "true");
          
          // auto upload on files change
          input.addEventListener("change", function(){
              
              // disable the input
              if (input.files.length > 0)
              {
                  input.setAttribute("disabled", "true");
                }
                
                sendMultipleFiles({
                
                    // list of files to upload
                    files:input.files,
                    
                    // clear the container 
                    onloadstart:function(){
                        div.innerHTML = "Init upload ... ";
                        sub.style.width = bar.style.width = "0px";
                    },
                    
                    // do something during upload ...
                    onprogress:function(rpe){
                        div.innerHTML = [
                            "Uploading: " + this.file.fileName,
                            "Sent: " + size(rpe.loaded) + " of " + size(rpe.total),
                            "Total Sent: " + size(this.sent + rpe.loaded) + " of " + size(this.total)
                        ].join("<br />");
                        sub.style.width = ((rpe.loaded * 200 / rpe.total) >> 0) + "px";
                        bar.style.width = (((this.sent + rpe.loaded) * 200 / this.total) >> 0) + "px";
                    },
                    
                    // fired when last file has been uploaded
                    onload:function(rpe, xhr){
                        div.innerHTML += ["",
                            "Server Response: " + xhr.responseText
                        ].join("<br />");
                        sub.style.width = bar.style.width = "200px";
                        // enable the input again
                        input.removeAttribute("disabled");
                        location.reload(true);
                    },
                    
                    // if something is wrong ... (from native instance or because of size)
                    onerror:function(){
                        div.innerHTML = "The file " + this.file.fileName + " is too big [" + size(this.file.fileSize) + "]";
                        
                        // enable the input again
                        input.removeAttribute("disabled");
                    }
                });
            }, false);
            
            sub.parentNode.className = bar.parentNode.className = "progress";
        };
/** Basic upload manager for single or multiple files (Safari 4 Compatible)
 * @author  Andrea Giammarchi
 * @blog    WebReflection [webreflection.blogspot.com]
 * @license Mit Style License
 */
var sendFile = 1024000000; // maximum allowed file size
                        // should be smaller or equal to the size accepted in the server for each file

// function to upload a single file via handler
sendFile = (function(toString, maxSize){
    var isFunction = function(Function){return  toString.call(Function) === "[object Function]";},
        split = "onabort.onerror.onloadstart.onprogress".split("."),
        length = split.length;
    return  function(handler){
        if(maxSize && maxSize < handler.file.fileSize){
            if(isFunction(handler.onerror))
                handler.onerror();
            return;
        };
        var xhr = new XMLHttpRequest,
            upload = xhr.upload;
        for(var
            xhr = new XMLHttpRequest,
            upload = xhr.upload,
            i = 0;
            i < length;
            i++
        )
            upload[split[i]] = (function(event){
                return  function(rpe){
                    if(isFunction(handler[event]))
                        handler[event].call(handler, rpe, xhr);
                };
            })(split[i]);
        upload.onload = function(rpe){
            if(handler.onreadystatechange === false){
                if(isFunction(handler.onload))
                    handler.onload(rpe, xhr);
            } else {
                setTimeout(function(){
                    if(xhr.readyState === 4){
                        if(isFunction(handler.onload))
                            handler.onload(rpe, xhr);
                    } else
                        setTimeout(arguments.callee, 15);
                }, 15);
            }
        };
        handler.url = location.href + "/uploadfile"
        xhr.open("post", handler.url, true);
        xhr.setRequestHeader("If-Modified-Since", "Mon, 26 Jul 1997 05:00:00 GMT");
        xhr.setRequestHeader("Cache-Control", "no-cache");
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
        xhr.setRequestHeader("X-File-Name", handler.file.name);
        xhr.setRequestHeader("X-File-Size", handler.file.size);
        xhr.setRequestHeader("X-File-Type", handler.file.type);
        xhr.setRequestHeader("Content-Type", "application/octet-stream");
        xhr.send(handler.file);
        return  handler;
    };
})(Object.prototype.toString, sendFile);

// function to upload multiple files via handler
function sendMultipleFiles(handler){
    var length = handler.files.length,
        i = 0,
        onload = handler.onload;
    handler.current = 0;
    handler.total = 0;
    handler.sent = 0;
    while(handler.current < length)
        handler.total += handler.files[handler.current++].fileSize;
    handler.current = 0;
    if(length){
        handler.file = handler.files[handler.current];
        sendFile(handler).onload = function(rpe, xhr){
            if(++handler.current < length){
                handler.sent += handler.files[handler.current - 1].fileSize;
                handler.file = handler.files[handler.current];
                sendFile(handler).onload = arguments.callee;
            } else if(onload) {
                handler.onload = onload;
                handler.onload(rpe, xhr);
            }
        };
    };
    return  handler;
};

