/**
 * @fileOverview This file has functions related to role index view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * RoleIndex View
 * @class RoleIndexView
 * @constructor
 * @extends Backbone.View
 */
App.RoleIndexView = Backbone.View.extend({
    template: JST['templates/roles'],
    tagName: 'tr',
    className: '',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {},
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            role: this.model
        }));
        this.showTooltip();
        return this;
    }
});
