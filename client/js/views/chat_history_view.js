/**
 * @fileOverview This file has functions related to chat view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Chat View
 * @class ChatView
 * @constructor
 * @extends Backbone.View
 */
App.ChatHistoryView = Backbone.View.extend({
    template: JST['templates/chat_history'],
    tagName: 'li',
    className: 'col-xs-12 row',
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        var self = this;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        _.bindAll(this, 'render');
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var name = this.model.attributes.username;
        this.model.set('name', name);
        var created = this.model.attributes.created.split('-');
        var cdate = created[2].split('T');
        var cmonth = parseInt(created[1]);
        cmonth = (cmonth > 10) ? cmonth : '0' + cmonth;
        var cyear = created[0];
        created = cyear + "-" + cmonth + "-" + cdate[0];
        var display_date = cmonth + "/" + cdate[0] + "/" + cyear;
        var objDate = new Date(display_date),
            locale = "en-us",
            month = objDate.toLocaleString(locale, {
                month: "long"
            });
        display_date = month + " " + cdate[0] + ", " + cyear;
        this.model.set('created_date', created);
        this.model.set('display_date', display_date);
        this.$el.html(this.template({
            chat_history: this.model,
            'title': 'Chat History'
        }));
        this.$('.timeago').timeago();
        this.showTooltip();
        return this;
    }
});
