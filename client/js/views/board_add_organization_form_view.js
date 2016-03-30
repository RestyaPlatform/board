/**
 * @fileOverview This file has functions related to board add organization view. This view calling from board add view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organizations collection(based on login user)
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardOrganizationForm View
 * @class BoardOrganizationFormView
 * @constructor
 * @extends Backbone.View
 */
App.BoardAddOrganizationFormView = Backbone.View.extend({
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
    template: JST['templates/board_add_organization_form'],
    tagName: 'div',
    className: 'form-group',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            organizations: this.model
        }));
        this.showTooltip();
        return this;
    }
});
