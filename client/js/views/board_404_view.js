/**
 * @fileOverview This file has functions related to board 404 view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined
 */
if (typeof App === 'undefined') {
    App = {};
}
/** 
 * ActivityAddForm View
 * @class ActivityAddFormView
 * @constructor
 * @extends Backbone.View
 */
App.Board404View = Backbone.View.extend({
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
    template: JST['templates/board_404'],
    tagName: 'section',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            authuser: this.model
        }));
        return this;
    }
});
