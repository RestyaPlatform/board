/**
 * @fileOverview This file has functions related to organization member confirm remove form view. This view calling from organization view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organization model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationMemberConfirmRemoveForm View
 * @class OrganizationMemberConfirmRemoveFormView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationMemberConfirmRemoveFormView = Backbone.View.extend({
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
    template: JST['templates/organization_member_confirm_remove_form'],
    tagName: 'div',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            organization_users: this.model
        }));
        this.showTooltip();
        return this;
    }
});
