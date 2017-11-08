/**
 * @fileOverview This file has functions related to card description view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: description model
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * DescriptionView View
 * @class DescriptionViewView
 * @constructor
 * @extends Backbone.View
 */
App.DescriptionView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.description = options.description;
        this.render(this.description);
    },
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
    template: JST['templates/card_description'],
    tagName: 'li',
    className: 'js-description col-xs-12',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    /*events: {
    },*/
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function(description) {
        this.$el.html(this.template({
            data: description,
        }));
        return this;
    }
});
