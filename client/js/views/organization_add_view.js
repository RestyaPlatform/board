/**
 * @fileOverview This file has functions related to organization add view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationAdd View
 * @class OrganizationAddView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationAddView = Backbone.View.extend({
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
    template: JST['templates/organization_add'],
    tagName: 'div',
    events: {
        'keyup #inputOrganizationDescription': 'validateDescription',
        'submit #OrganizationAddForm': 'addOrganization',

    },
    /**
     * validateDescription()
     * to validate description textarea
     * @param NULL
     * @return null
     */
    validateDescription: function() {
        var self = this;
        var q = this.$el.find('#inputOrganizationDescription').val();
        console.log(q);
        if (!_.isEmpty(q)) {
            self.$el.find('.error-msg-name').remove();
            self.$el.find('.error-msg-description').remove();
            self.$el.find('#js-add-organization').removeClass('disabled');
        } else {
            self.$el.find('.error-msg-name').remove();
            self.$el.find('.error-msg-description').remove();
            self.$el.find('#js-add-organization').addClass('disabled');
            $('<div class="error-msg-description text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputOrganizationDescription');
        }
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({}));
        this.showTooltip();
        return this;
    },
    addOrganization: function(e) {
        $('#js-add-organization').addClass('disabled');
        var data = $(e.target).serializeObject();
        if ($.trim(data.name) === '' || $.trim(data.description) === '') {
            if ($.trim(data.name) === '' && $.trim(data.description) === '') {
                $('.error-msg-name').remove();
                $('.error-msg-description').remove();
                $('<div class="error-msg-name text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputOrganizationName');
                $('<div class="error-msg-description text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputOrganizationDescription');
            } else if ($.trim(data.name) === '') {
                $('.error-msg-name').remove();
                $('.error-msg-description').remove();
                $('<div class="error-msg-name text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputOrganizationName');
            } else if ($.trim(data.description) === '') {
                $('.error-msg-name').remove();
                $('.error-msg-description').remove();
                $('<div class="error-msg-description text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputOrganizationDescription');
            }
        } else {
            $('.error-msg-name').remove();
            $('.error-msg-description').remove();
            var organization = new App.Organization();
            organization.url = api_url + 'organizations.json';
            organization.set(data);
            if (!_.isUndefined(data.name) && data.name !== null && $.trim(data.name) !== "") {
                organization.save(data, {
                    success: function(model, response) {
                        $('#js-add-organization').removeClass('disabled');
                        organization.set('id', parseInt(response.id));
                        auth_user_organizations.add(organization);
                        data.id = parseInt(response.id);
                        var Auth = JSON.parse($.cookie('auth'));
                        if (auth_user_organizations === null) {
                            auth_user_organizations = [];
                        }
                        auth_user_organizations.add(data);
                        app.navigate('#/organization/' + response.id, {
                            trigger: true,
                            replace: true
                        });
                    }
                });
            } else {
                this.flash(i18next.t('Enter organization name'), i18next.t('Organization name is empty'));
            }
        }
        return false;
    }
});
