/**
 * Backbone.js defered view loader
 *
 * @author Samuel ROZE
 * @link sroze.io
 * @link github.com/sroze
 */
(function(){
    /**
     * TemplateManager object provides an async template loading and caching
     * system.
     * 
     */
    Backbone.TemplateManager = {
        // Already loaded templates
        templates: {},
        
        // Base loading template URL
        baseUrl: '/templates/{name}',
        
        // Templates that are currently loading
        loadings: new Array(),
        
        // Save current rendered views
        currentViews: {},
        
        // Waiting defereds
        queues: {},
        
        set: function (name, data) {
            this.templates[name] = data;
            
            // Resolve queues
            var queue = this.queues[name];
            if (queue) {
                for (var i = 0; i < queue.length; i++) {
                    queue[i].dfd.resolveWith(queue[i].context, [data]);
                }
            }
            this.queues[name] = new Array();
        },
        
        notLoading: function (name) {
            var index = this.loadings.indexOf(name);
            if (index != -1) {
                var rest = this.loadings.slice(index + 1 || this.loadings.length);
                this.loadings.length = index < 0 ? this.loadings.length + index : index;
                return this.loadings.push.apply(this, rest);
            }
        },
        
        get: function(name, context) 
        {
            if (name == null) {
                throw "Template name must be defined";
            }
            
            var dfd = $.Deferred();
            
            // If the template is already loaded, resolve immediately
            if (this.templates[name]) {
                dfd.resolveWith(context, [this.templates[name]]);
            } else {
                // Add this request to queue
                if (!this.queues[name]) {
                    this.queues[name] = new Array();
                }
                this.queues[name].push({dfd: dfd, context: context});
                
                // Is this template loading ?
                if (this.loadings.indexOf(name) == -1) {
                    this.loadings.push(name);
                    
                    // Compute template URL
                    var url = Backbone.TemplateManager.baseUrl.replace('{name}', name);
                
                    // Start template loading
                    $.get(url, function (data) {
                        // Compute template
                        var template = _.template(data);
                        
                        // Save template in "cache"
                        Backbone.TemplateManager.notLoading(name);
                        Backbone.TemplateManager.set(name, template);
                    }).error(function(){
                        Backbone.TemplateManager.notLoading(name);
                    });
                }
            }
            
            return dfd.promise();
        }
    };

    /**
     * Lmc.View improves the backbone model view, with async template
     * loading for instance.
     * 
     */
    Backbone.DeferedView = Backbone.View.extend({
        templateName: null,
        container: null,
        loadedCountDown: 1,
        
        deferedRender: function(event) {
            // Fetch the template from the TemplateManager and when complete 
            // call the normal render method
            var tn = this.templateName;
            /*var render = $.when(
                Backbone.TemplateManager.get(this.templateName, this)
            ).then(function(resultTemplate){
                this.template = resultTemplate;
                this.render();
                this.isLoaded(true);
                
                if (event != undefined && typeof event == "function") {
                    event();
                }
            });*/

            return this;
        },
        
        getHelpers: function () {
            return {
                displaySize: function (bytes) {
                    var sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
                    if (bytes == 0) return '0 B';
                    var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
                    return (bytes / Math.pow(1024, i)).toFixed(2) + ' ' + sizes[i];
                },
                displayDate: function (timestamp) {
                    return new Date(timestamp).toLocaleString();
                }
            }
        },
        
        renderTo: function (container, event) {
            if (Backbone.TemplateManager.currentViews[container]){
                Backbone.TemplateManager.currentViews[container].close();
            }
            
            Backbone.TemplateManager.currentViews[container] = this;
            this.isLoaded(false);
            $(container).html(this.deferedRender(event).el);
            
            return this;
        },
        
        isLoaded: function (loaded) {
            if (loaded != undefined) {
                this.loadedCountDown += (loaded ? -1 : 1);
                if (this.loadedCountDown > 0) {
                    $(this.el).addClass('loading');
                } else {
                    $(this.el).removeClass('loading');
                }
            }
            
            return this.loadedCountDown == 0;
        },
        
        close: function() {
            if (typeof this.onPreClose == "function") {
                this.onPreClose();
            }
            this.remove();
            this.unbind();
            if (typeof this.onClose == "function") {
                this.onClose();
            }
        }
    });
}());