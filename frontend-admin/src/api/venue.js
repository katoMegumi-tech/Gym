import request from '@/utils/request'

export function getVenueList(params) {
  return request({
    url: '/venues',
    method: 'get',
    params
  })
}

export function getVenueDetail(id) {
  return request({
    url: `/venues/${id}`,
    method: 'get'
  })
}

export function createVenue(data) {
  return request({
    url: '/venues',
    method: 'post',
    data
  })
}

export function updateVenue(id, data) {
  return request({
    url: `/venues/${id}`,
    method: 'put',
    data
  })
}

export function deleteVenue(id) {
  return request({
    url: `/venues/${id}`,
    method: 'delete'
  })
}
