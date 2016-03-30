/**
 * @fileOverview This file has functions related to activity add view. This view calling from modal card  view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model and it's related values. It contain all board based object @see Available Object in App.ModalCardView
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
App.ActivityAddFormView = Backbone.View.extend({
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
    template: JST['templates/activity_add_form'],
    tagName: 'form',
    className: 'js-add-comment',
    id: 'AddActivityForm',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            card: this.model
        }));
        this.showTooltip();
        return this;
    }
});
